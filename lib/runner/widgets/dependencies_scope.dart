import 'package:architectures/runner/models/dependency_container.dart';
import 'package:flutter/material.dart';

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    super.key,
    required super.child,
    required this.dependencies,
  });

  static DependencyContainer of(BuildContext context) {
    final scope =
        context
            .getElementForInheritedWidgetOfExactType<DependenciesScope>()
            ?.widget;
    final checkScope = scope is DependenciesScope;
    assert(checkScope, "No DependenciesScope found in context");
    return (scope as DependenciesScope).dependencies;
  }

  final DependencyContainer dependencies;

  @override
  bool updateShouldNotify(DependenciesScope old) {
    return false;
  }
}
