import 'dart:convert';

import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';

final class BookingLocalService implements IBookingService {
  BookingLocalService({required SharedPreferencesHelper sharedPreferencesHelper})
    : _sharedPreferencesHelper = sharedPreferencesHelper;

  final SharedPreferencesHelper _sharedPreferencesHelper;
  static const _bookingsKey = 'bookings';

  @override
  Future<bool> createBooking(Booking booking) async {
    final encoded = jsonEncode(booking.toJson());
    await _sharedPreferencesHelper.saveString("${_bookingsKey}_${booking.id}", encoded);
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    await _sharedPreferencesHelper.remove("${_bookingsKey}_$id");
    return true;
  }

  @override
  Future<Booking?> getBooking(int id) async {
    final booking = _sharedPreferencesHelper.getString("${_bookingsKey}_$id");
    if (booking == null) return null;
    return Booking.fromJson(jsonDecode(booking));
  }

  @override
  Future<List<BookingSummary>> getBookingsList() async {
    final raw = _sharedPreferencesHelper.getString(_bookingsKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => BookingSummary.fromJson(e)).toList();
    }
    return <BookingSummary>[];
  }
}
