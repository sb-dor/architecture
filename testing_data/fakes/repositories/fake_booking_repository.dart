import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';

import '../../temp_data/fake_bookings.dart';

class FakeBookingRepositoryImpl implements IBookingRepository {
  @override
  Future<bool> createBooking(Booking booking) => Future.value(true);

  @override
  Future<bool> delete(int id) => Future.value(true);

  @override
  Future<Booking?> getBooking(int id) => Future.value(kBooking);

  @override
  Future<List<BookingSummary>> getBookingsList() => Future.value([kBookingSummary]);
}
