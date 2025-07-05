import 'package:architectures/ui/home/controller/home_controller.dart';
import 'package:architectures/ui/logout/controllers/logout_controller.dart';
import 'package:architectures/ui/results/controllers/result_controller.dart';
import 'package:architectures/ui/search_from/controller/search_form_controller.dart';
import 'package:architectures/utils/shared_preferences_helper.dart';
import 'package:logger/logger.dart';

class DependencyContainer {
  DependencyContainer({
    required this.homeController,
    required this.searchFormController,
    required this.logoutController,
    required this.resultController,
    required this.sharedPreferencesHelper,
    required this.logger,
  });

  final HomeController homeController;

  final SearchFormController searchFormController;

  final LogoutController logoutController;

  final ResultController resultController;

  final SharedPreferencesHelper sharedPreferencesHelper;

  final Logger logger;
}

/// A special version of [DependenciesContainer] that is used in tests.
///
/// In order to use [DependenciesContainer] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
base class TestDependencyContainer implements DependencyContainer {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
