import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';

final class BookingLocalService implements BookingService {
  @override
  Future<void> createBooking(Booking booking) {
    // TODO: implement createBooking
    throw UnimplementedError();
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Booking> getBooking(int id) {
    // TODO: implement getBooking
    throw UnimplementedError();
  }

  @override
  Future<List<BookingSummary>> getBookingsList() {
    // TODO: implement getBookingsList
    throw UnimplementedError();
  }
}
