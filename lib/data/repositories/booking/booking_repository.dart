import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';

abstract interface class BookingRepository {}

final class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required this.bookingRemoteService,
    required this.bookingLocalService,
    required this.internetConnectionCheckerHelper,
  });

  final BookingService bookingRemoteService;
  final BookingService bookingLocalService;
  final InternetConnectionCheckerHelper internetConnectionCheckerHelper;
}
