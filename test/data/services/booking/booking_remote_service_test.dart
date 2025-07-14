import 'dart:convert';

import 'package:architectures/data/services/booking/booking_remote_service.dart';
import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:mockito/mockito.dart';

import '../../../../testing_data/temp_data/fake_bookings.dart';

void main() {
  final String mainUrl = "";
  final Map<String, dynamic> failedResult = {"success": false};
  final Map<String, dynamic> successResult = {"success": true};
  final List<BookingSummary> bookings = [kBookingSummary];

  group('Booking creation testing', () {
    //
    test('Booking creation testing with success result', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(kBooking.toJson()), 200),
      );

      final IBookingService bookingRemoteService = BookingRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final delete = await bookingRemoteService.createBooking(kBooking);

      expect(delete, isTrue);
      mockedClient.close();
    });

    //
    test('Booking creation testing with failed result', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(failedResult), 500),
      );

      final IBookingService bookingRemoteService = BookingRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final delete = await bookingRemoteService.createBooking(kBooking);

      expect(delete, isFalse);
      mockedClient.close();
    });
  });

  group('Booking deletion testing', () {
    //
    test('Booking delete testing with success result', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(successResult), 200),
      );

      final IBookingService bookingRemoteService = BookingRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final delete = await bookingRemoteService.delete(kBooking.id!);

      expect(delete, isTrue);
      mockedClient.close();
    });

    //
    test('Booking deletion testing with failed result', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(failedResult), 500),
      );

      final IBookingService bookingRemoteService = BookingRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final delete = await bookingRemoteService.delete(kBooking.id!);

      expect(delete, isFalse);
      mockedClient.close();
    });
  });

  group('Booking fetching test', () {
    //
    test('Booking get - testing with success result', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(kBooking.toJson()), 200),
      );

      final IBookingService bookingRemoteService = BookingRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final delete = await bookingRemoteService.getBooking(kBooking.id!);

      expect(delete, isNotNull);
      mockedClient.close();
    });

    //
    test('Booking get - testing with failed result', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(failedResult), 500),
      );

      final IBookingService bookingRemoteService = BookingRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final delete = await bookingRemoteService.getBooking(kBooking.id!);

      expect(delete, isNull);
      mockedClient.close();
    });
  });

  group('Booking fetching bookingList', () {
    //
    test('BookingList get - testing with success result', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async =>
            http.Response(jsonEncode(bookings.map((element) => element.toJson()).toList()), 200),
      );

      final IBookingService bookingRemoteService = BookingRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final delete = await bookingRemoteService.getBookingsList();

      expect(delete, isNotEmpty);
      mockedClient.close();
    });

    //
    test('BookingList get - testing with failed result', () async {
      //
      final mockedClient = http_testing.MockClient(
        (_) async => http.Response(jsonEncode(failedResult), 500),
      );

      final IBookingService bookingRemoteService = BookingRemoteService(
        mainUrl: mainUrl,
        client: mockedClient,
      );

      final delete = await bookingRemoteService.getBookingsList();

      expect(delete, isEmpty);
      mockedClient.close();
    });
  });
}
