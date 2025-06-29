import 'package:architectures/ui/home/controller/home_controller.dart';

class DependencyContainer {
  DependencyContainer({required this.homeController});

  final HomeController homeController;
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
