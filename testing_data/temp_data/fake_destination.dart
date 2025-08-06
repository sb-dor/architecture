import 'package:architectures/models/destination.dart';

final kDestination1 = Destination(
  ref: 'DESTINATION',
  name: 'name1',
  country: 'country1',
  continent: 'Europe',
  knownFor: 'knownFor1',
  tags: ['tags1'],
  imageURL: 'imageUrl1',
);

final kDestination2 = Destination(
  ref: 'ref2',
  name: 'name2',
  country: 'country2',
  continent: 'Europe',
  knownFor: 'knownFor2',
  tags: ['tags2'],
  imageURL: 'imageUrl2',
);

final List<Destination> kTestDestinations = [
  Destination(
    ref: 'DESTINATION',
    name: 'Paris',
    country: 'France',
    continent: 'Europe',
    knownFor: 'Eiffel Tower',
    tags: ['romantic', 'historic'],
    imageURL: 'https://example.com/paris.jpg',
  ),
  Destination(
    ref: 'DESTINATION2',
    name: 'Tokyo',
    country: 'Japan',
    continent: 'Asia',
    knownFor: 'Technology and culture',
    tags: ['modern', 'traditional'],
    imageURL: 'https://example.com/tokyo.jpg',
  ),
  Destination(
    ref: 'DESTINATION3',
    name: 'New York',
    country: 'USA',
    continent: 'North America',
    knownFor: 'Skyscrapers',
    tags: ['urban', 'fashion'],
    imageURL: 'https://example.com/newyork.jpg',
  ),
  Destination(
    ref: 'DESTINATION4',
    name: 'Cape Town',
    country: 'South Africa',
    continent: 'Africa',
    knownFor: 'Table Mountain',
    tags: ['nature', 'beach'],
    imageURL: 'https://example.com/capetown.jpg',
  ),
  Destination(
    ref: 'DESTINATION5',
    name: 'Sydney',
    country: 'Australia',
    continent: 'Australia',
    knownFor: 'Opera House',
    tags: ['coastal', 'landmark'],
    imageURL: 'https://example.com/sydney.jpg',
  ),
];
