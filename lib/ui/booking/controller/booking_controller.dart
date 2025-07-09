import 'package:architectures/data/repositories/activities/activities_repository.dart';
import 'package:architectures/data/repositories/booking/booking_repository.dart';
import 'package:architectures/data/repositories/destination/destination_repository.dart';
import 'package:architectures/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:architectures/models/booking.dart';
import 'package:architectures/models/destination.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';

class BookingController extends ChangeNotifier {
  BookingController({
    required IItineraryConfigRepository itineraryConfigRepository,
    required IBookingRepository bookingRepository,
    required IDestinationRepository destinationRepository,
    required IActivitiesRepository activitiesRepository,
    required Logger logger,
  }) : _itineraryConfigRepository = itineraryConfigRepository,
       _iBookingRepository = bookingRepository,
       _destinationRepository = destinationRepository,
       _activitiesRepository = activitiesRepository,
       _logger = logger;

  final IItineraryConfigRepository _itineraryConfigRepository;
  final IBookingRepository _iBookingRepository;
  final IDestinationRepository _destinationRepository;
  final IActivitiesRepository _activitiesRepository;
  final Logger _logger;

  Booking? _booking;

  Booking? get booking => _booking;

  bool creatingBooking = false;

  Future<void> createBooking() async {
    if (creatingBooking) return;

    creatingBooking = true;
    notifyListeners();

    _logger.log(Level.debug, 'Loading booking');
    final itineraryConfig = await _itineraryConfigRepository.getItineraryConfig();

    if (itineraryConfig.destination == null) {
      print("return des 1");
      creatingBooking = false;
      notifyListeners();
      return;
    }

    final destinationResult = await _fetchDestination(itineraryConfig.destination!);

    if (itineraryConfig.activities.isEmpty) {
      print("return activities");
      creatingBooking = false;
      notifyListeners();
      return;
    }

    final activitiesResult = await _activitiesRepository.getByDestination(
      itineraryConfig.destination!,
    );

    final activities =
        activitiesResult
            .where((activity) => itineraryConfig.activities.contains(activity.ref))
            .toList();

    if (itineraryConfig.startDate == null || itineraryConfig.endDate == null) {
      print("return dates");
      creatingBooking = false;
      notifyListeners();
      return;
    }

    final booking = Booking(
      startDate: itineraryConfig.startDate!,
      endDate: itineraryConfig.endDate!,
      destination: destinationResult,
      activities: activities,
    );

    final save = await _iBookingRepository.createBooking(booking);

    print("coming here $save | $booking");

    if (save) {
      _booking = booking;
    }

    creatingBooking = false;

    notifyListeners();
  }

  Future<void> load(int id) async {
    _booking = await _iBookingRepository.getBooking(id);
    notifyListeners();
  }

  Future<Destination> _fetchDestination(String destinationRef) async {
    final result = await _destinationRepository.getDestinations();

    return result.firstWhere((destination) => destination.ref == destinationRef);
  }

  Future<void> shareBooking(final String text) async {
    if (_booking == null) return;
    _logger.log(Level.debug, 'Sharing booking: $text');
    try {
      await SharePlus.instance.share(ShareParams(text: text));
      _logger.log(Level.debug, 'Shared booking');
    } on Exception catch (error) {
      _logger.log(Level.debug, 'Failed to share booking: $error');
    }
  }
}
