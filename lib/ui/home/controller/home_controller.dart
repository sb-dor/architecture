import 'dart:collection';

import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/user_repository/user_repository.dart';
import 'package:architectures/models/booking_summary.dart';
import 'package:architectures/models/user.dart';
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required IBookingRepository bookingRepository,
    required IUserRepository userRepository,
  }) : _bookingRepository = bookingRepository,
       _userRepository = userRepository;

  final IBookingRepository _bookingRepository;
  final IUserRepository _userRepository;

  User? _user;

  User? get user => _user;

  /// Items in an [UnmodifiableListView] can't be directly modified,
  /// but changes in the source list can be modified. Since _bookings
  /// is private and bookings is not, the view has no way to modify the
  /// list directly.
  List<BookingSummary> _bookingSummary = [];

  UnmodifiableListView<BookingSummary> get bookingSummary => UnmodifiableListView(_bookingSummary);

  String? _error;

  String? get error => _error;

  Future<void> load() async {
    try {
      _user = await _userRepository.user();
      _bookingSummary = await _bookingRepository.getBookingsList();
    } catch (error, stackTrace) {
      _error = error.toString();
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteBooking(int id) async {
    try {
      await _bookingRepository.delete(id);
      _bookingSummary = await _bookingRepository.getBookingsList();
    } catch (error, stackTrace) {
      _error = error.toString();
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      notifyListeners();
    }
  }
}
