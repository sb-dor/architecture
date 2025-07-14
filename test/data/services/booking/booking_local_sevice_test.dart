import 'dart:convert';

import 'package:architectures/data/services/booking/booking_local_service.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_bookings.dart';
import 'booking_local_sevice_test.mocks.dart';

@GenerateMocks([SharedPreferencesHelper])
void main() {
  final int id = 1;
  late final MockSharedPreferencesHelper mockSharedPreferencesHelper;
  late final BookingLocalService bookingLocalService;

  setUpAll(() {
    mockSharedPreferencesHelper = MockSharedPreferencesHelper();
    bookingLocalService = BookingLocalService(sharedPreferencesHelper: mockSharedPreferencesHelper);
  });

  group('Local create-delete booking test', () {
    //
    test('Test creation', () {
      when(
        mockSharedPreferencesHelper.saveString(any, any),
      ).thenAnswer((_) async => Future<void>.value());

      final create = bookingLocalService.createBooking(kBooking);

      expect(create, completes);
      verify(mockSharedPreferencesHelper.saveString(any, any)).called(1);
    });

    //
    test('Test deletion', () {
      when(mockSharedPreferencesHelper.remove(any)).thenAnswer((_) => Future<void>.value());

      final delete = bookingLocalService.delete(id);

      expect(delete, completes);
      verify(mockSharedPreferencesHelper.remove(any)).called(1);
    });
  });

  //
  group('Test local getBooking', () {
    //
    test('Test getBooking for nullable value', () async {
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(null);

      final getBooking = await bookingLocalService.getBooking(id);

      expect(getBooking, isNull);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });

    //
    test('Test getBooking for non-nullable value', () async {
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(jsonEncode(kBooking.toJson()));

      final getBooking = await bookingLocalService.getBooking(id);

      expect(getBooking, isNotNull);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });
  });

  //
  group('Test local getBookingsList', () {
    //
    test('Test getBookingList for empty array: when list is empty', () async {
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(jsonEncode(List.empty()));

      final getBookings = await bookingLocalService.getBookingsList();

      expect(getBookings, isEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });

    //
    test('Test getBookingList for empty array: when list is null', () async {
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(null);

      final getBookings = await bookingLocalService.getBookingsList();

      expect(getBookings, isEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });

    //
    test('Test getBookingList for non-empty array', () async {
      final data = [kBookingSummary].map((element) => element.toJson()).toList();
      //
      when(mockSharedPreferencesHelper.getString(any)).thenReturn(jsonEncode(data));

      final getBookings = await bookingLocalService.getBookingsList();

      expect(getBookings, isNotEmpty);
      verify(mockSharedPreferencesHelper.getString(any)).called(1);
    });
  });
}
