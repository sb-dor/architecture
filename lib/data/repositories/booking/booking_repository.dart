import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class IBookingRepository {
  Future<List<BookingSummary>> getBookingsList();

  Future<Booking> getBooking(int id);

  Future<void> createBooking(Booking booking);

  Future<void> delete(int id);
}

final class BookingRepositoryImpl implements IBookingRepository {
  BookingRepositoryImpl({
    required this.bookingRemoteService,
    required this.bookingLocalService,
    required this.internetConnectionCheckerHelper,
  });

  final IBookingService bookingRemoteService;
  final IBookingService bookingLocalService;
  final InternetConnectionCheckerHelper internetConnectionCheckerHelper;

  @override
  Future<void> createBooking(Booking booking) async {
    final hasInternet = await internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternet) {
      return bookingRemoteService.createBooking(booking);
    } else {
      return bookingLocalService.createBooking(booking);
    }
  }

  @override
  Future<void> delete(int id) async {
    final hasInternet = await internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternet) {
      return bookingRemoteService.delete(id);
    } else {
      return bookingLocalService.delete(id);
    }
  }

  @override
  Future<Booking> getBooking(int id) async {
    final hasInternet = await internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternet) {
      return bookingRemoteService.getBooking(id);
    } else {
      return bookingLocalService.getBooking(id);
    }
  }

  @override
  Future<List<BookingSummary>> getBookingsList() async {
    final hasInternet = await internetConnectionCheckerHelper.hasAccessToInternet();
    if (hasInternet) {
      return bookingRemoteService.getBookingsList();
    } else {
      return bookingLocalService.getBookingsList();
    }
  }
}
