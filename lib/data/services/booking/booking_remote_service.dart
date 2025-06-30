import 'dart:convert';
import 'dart:io';

import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';
import 'package:architectures/utils/constants.dart';
import 'package:http/http.dart' as http;

final class BookingRemoteService implements BookingService {
  BookingRemoteService({required this.mainUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String mainUrl;
  final http.Client _client;

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
  Future<List<BookingSummary>> getBookingsList() async {
    final request = await _client.get(
      Uri.parse("$mainUrl/booking"),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${Constants.token}"},
    );
    if (request.statusCode == 200) {
      final json = jsonDecode(request.body) as List<dynamic>;
      final bookings = json.map((element) => BookingSummary.fromJson(element)).toList();
      return bookings;
    }

    return <BookingSummary>[];
  }
}
