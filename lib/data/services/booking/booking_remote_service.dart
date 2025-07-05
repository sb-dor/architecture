import 'dart:convert';
import 'dart:io';

import 'package:architectures/data/services/booking/booking_service.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/booking_summary.dart';
import 'package:architectures/utils/constants.dart';
import 'package:http/http.dart' as http;

final class BookingRemoteService implements IBookingService {
  BookingRemoteService({required String mainUrl, http.Client? client})
    : _mainUrl = mainUrl,
      _client = client ?? http.Client();

  final String _mainUrl;
  final http.Client _client;

  @override
  Future<bool> createBooking(Booking booking) async {
    final request = await _client.post(
      Uri.parse('$_mainUrl/booking'),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${Constants.token}"},
      body: jsonEncode(booking.toJson()),
    );
    print("coming requst create booking: ${request.body}");
    if (request.statusCode == 201) {
      final booking = BookingSummary.fromJson(jsonDecode(request.body));
      return true;
    }
    return false;
  }

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Booking?> getBooking(int id) async {
    final request = await _client.get(
      Uri.parse('$_mainUrl/booking/$id'),
      headers: {HttpHeaders.authorizationHeader: "Bearer ${Constants.token}"},
    );
    print("coming data: ${request.body}");
    if (request.statusCode == 200) {
      final booking = Booking.fromJson(jsonDecode(request.body));
      return booking;
    }
    return null;
  }

  @override
  Future<List<BookingSummary>> getBookingsList() async {
    final request = await _client.get(
      Uri.parse("$_mainUrl/booking"),
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
