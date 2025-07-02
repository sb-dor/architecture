import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';

abstract interface class IBookingService {
  Future<List<BookingSummary>> getBookingsList();

  Future<Booking> getBooking(int id);

  Future<void> createBooking(Booking booking);

  Future<void> delete(int id);
}
