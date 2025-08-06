import 'package:architectures/models/activity.dart';

const kActivity = Activity(
  description: 'DESCRIPTION',
  destinationRef: 'DESTINATION',
  duration: 3,
  familyFriendly: true,
  imageUrl: 'http://example.com/img.png',
  locationName: 'LOCATION NAME',
  name: 'NAME',
  price: 3,
  ref: 'DESTINATION',
  timeOfDay: TimeOfDay.afternoon,
);

final fakeActivities = [
  Activity(
    description: 'Enjoy a scenic hike through the lush green hills.',
    destinationRef: 'dest_001',
    duration: 2,
    familyFriendly: true,
    imageUrl:
        'https://storage.googleapis.com/tripedia-images/activities/alaska_glacier-trekking-and-ice-climbing.jpg',
    locationName: 'Green Valley Trail',
    name: 'Nature Hike',
    price: 0,
    ref: 'activity_001',
    timeOfDay: TimeOfDay.morning,
  ),
  Activity(
    description: 'Explore local history with a guided museum tour.',
    destinationRef: 'dest_002',
    duration: 1,
    familyFriendly: true,
    imageUrl:
        'https://storage.googleapis.com/tripedia-images/activities/alaska_wildlife-viewing-cruise.jpg',
    locationName: 'City History Museum',
    name: 'Museum Tour',
    price: 5,
    ref: 'activity_002',
    timeOfDay: TimeOfDay.afternoon,
  ),
  Activity(
    description: 'Experience a thrilling adventure in the mountains.',
    destinationRef: 'dest_003',
    duration: 4,
    familyFriendly: false,
    imageUrl:
        'https://storage.googleapis.com/tripedia-images/activities/alaska_dog-sledding-experience.jpg',
    locationName: 'Rocky Peaks',
    name: 'Mountain Climbing',
    price: 20,
    ref: 'activity_003',
    timeOfDay: TimeOfDay.morning,
  ),
  Activity(
    description: 'Relax and enjoy a boat ride at sunset.',
    destinationRef: 'dest_004',
    duration: 2,
    familyFriendly: true,
    imageUrl:
        'https://storage.googleapis.com/tripedia-images/activities/alaska_hiking-in-denali-national-park.jpg',
    locationName: 'Sunset Lake',
    name: 'Sunset Boat Ride',
    price: 10,
    ref: 'activity_004',
    timeOfDay: TimeOfDay.evening,
  ),
  Activity(
    description: 'A fun-filled water park with slides and pools.',
    destinationRef: 'dest_005',
    duration: 5,
    familyFriendly: true,
    imageUrl:
        'https://storage.googleapis.com/tripedia-images/activities/alaska_northern-lights-viewing.jpg',
    locationName: 'Splash World',
    name: 'Water Park Day',
    price: 15,
    ref: 'activity_005',
    timeOfDay: TimeOfDay.afternoon,
  ),
];
