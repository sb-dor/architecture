import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidgetController {
  const TestWidgetController(this.tester);

  final WidgetTester tester;

  /// Pumps the given [widget] and waits for the widget to be rendered.
  Future<void> pumpWidget(
    Widget widget, {
    bool wrapWithMaterialApp = true,
    DependencyContainer? dependencies,
  }) async {
    var child = widget;

    if (wrapWithMaterialApp) {
      child = MaterialApp(home: child);
    }

    if (dependencies != null) {
      child = DependenciesScope(dependencies: dependencies, child: child);
    }

    await tester.pumpWidget(child);
  }
}
