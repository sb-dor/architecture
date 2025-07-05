import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class IBookingRepository {
  Future<List<BookingSummary>> getBookingsList();

  Future<Booking> getBooking(int id);

  Future<bool> createBooking(Booking booking);

  Future<void> delete(int id);
}

final class BookingRepositoryImpl implements IBookingRepository {
  BookingRepositoryImpl({
    required IBookingService bookingRemoteService,
    required IBookingService bookingLocalService,
    required InternetConnectionCheckerHelper internetConnectionCheckerHelper,
  }) : _bookingRemoteService = bookingRemoteService,
       _bookingLocalService = bookingLocalService,
       _internetConnectionCheckerHelper = internetConnectionCheckerHelper;

  final IBookingService _bookingRemoteService;
  final IBookingService _bookingLocalService;
  final InternetConnectionCheckerHelper _internetConnectionCheckerHelper;

  @override
  Future<bool> createBooking(Booking booking) async {
    final hasInternet = await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternet) {
      return _bookingRemoteService.createBooking(booking);
    } else {
      return _bookingLocalService.createBooking(booking);
    }
  }

  @override
  Future<void> delete(int id) async {
    final hasInternet = await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternet) {
      return _bookingRemoteService.delete(id);
    } else {
      return _bookingLocalService.delete(id);
    }
  }

  @override
  Future<Booking> getBooking(int id) async {
    final hasInternet = await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternet) {
      return _bookingRemoteService.getBooking(id);
    } else {
      return _bookingLocalService.getBooking(id);
    }
  }

  @override
  Future<List<BookingSummary>> getBookingsList() async {
    final hasInternet = await _internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternet) {
      return _bookingRemoteService.getBookingsList();
    } else {
      return _bookingLocalService.getBookingsList();
    }
  }
}
