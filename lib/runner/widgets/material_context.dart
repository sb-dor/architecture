import 'package:architectures/runner/models/dependency_container.dart';
import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/home/widgets/home_widget.dart';
import 'package:flutter/material.dart';

class MaterialContext extends StatelessWidget {
  const MaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: dependencyContainer,
      child: MaterialApp(home: HomeWidget()),
    );
  }
}
