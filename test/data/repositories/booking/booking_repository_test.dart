import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/utils/internet_connection_checker_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_bookings.dart';
import 'booking_repository_test.mocks.dart';

@GenerateMocks([IBookingService, InternetConnectionCheckerHelper])
void main() {
  late final MockIBookingService mockIBookingRemoteService;
  late final MockIBookingService mockIBookingLocalService;
  late final MockInternetConnectionCheckerHelper mockInternetConnectionChecker;

  late final IBookingRepository bookingRepository;

  setUpAll(() {
    mockIBookingRemoteService = MockIBookingService();
    mockIBookingLocalService = MockIBookingService();
    mockInternetConnectionChecker = MockInternetConnectionCheckerHelper();

    bookingRepository = BookingRepositoryImpl(
      bookingRemoteService: mockIBookingRemoteService,
      bookingLocalService: mockIBookingLocalService,
      internetConnectionCheckerHelper: mockInternetConnectionChecker,
    );
  });

  group('Booking Repository Remote test', () {
    //
    test('Test getBookingsList for success', () async {
      // arrange
      when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => true);
      when(mockIBookingRemoteService.getBookingsList()).thenAnswer((_) async => [kBookingSummary]);

      // act
      final getBookingsList = await bookingRepository.getBookingsList();

      // assert
      expect(getBookingsList, isNotEmpty);
      verify(mockInternetConnectionChecker.hasAccessToInternet()).called(1);
      verify(mockIBookingRemoteService.getBookingsList()).called(1);
    });

    //
    test('Test getBooking for null', () async {
      // arrange
      when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => true);
      when(mockIBookingRemoteService.getBooking(any)).thenAnswer((_) async => null);

      // act
      final getBookingsList = await bookingRepository.getBooking(kBooking.id!);

      // assert
      expect(getBookingsList, isNull);
      verify(mockInternetConnectionChecker.hasAccessToInternet()).called(1);
      verify(mockIBookingRemoteService.getBooking(any)).called(1);
    });

    //
    test('Test createBooking for success', () async {
      // arrange
      when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => true);
      when(mockIBookingRemoteService.createBooking(any)).thenAnswer((_) async => true);

      // act
      final getBookingsList = await bookingRepository.createBooking(kBooking);

      // assert
      expect(getBookingsList, isTrue);
      verify(mockInternetConnectionChecker.hasAccessToInternet()).called(1);
      verify(mockIBookingRemoteService.createBooking(any)).called(1);
    });

    //
    test('Test delete for fail', () async {
      // arrange
      when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => true);
      when(mockIBookingRemoteService.delete(any)).thenAnswer((_) async => false);

      // act
      final getBookingsList = await bookingRepository.delete(kBooking.id!);

      // assert
      expect(getBookingsList, isFalse);
      verify(mockInternetConnectionChecker.hasAccessToInternet()).called(1);
      verify(mockIBookingRemoteService.delete(any)).called(1);
    });
  });
}
