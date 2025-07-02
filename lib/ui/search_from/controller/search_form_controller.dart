import 'package:architectures/data/repositories/continent/continent_repository.dart';
import 'package:flutter/foundation.dart';

class SearchFormController extends ChangeNotifier {
  SearchFormController({required this.continentRepository});

  final IContinentRepository continentRepository;
}
