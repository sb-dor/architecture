// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/search_from/controller/search_form_controller.dart';
import 'package:flutter/material.dart';

const String searchFormSubmitButtonKey = 'submit-button';

/// Search form submit button
///
/// The button is disabled when the form is data is incomplete.
/// When tapped, it navigates to the [ResultsScreen]
/// passing the search options as query parameters.
class SearchFormSubmit extends StatefulWidget {
  const SearchFormSubmit({super.key});

  @override
  State<SearchFormSubmit> createState() => _SearchFormSubmitState();
}

class _SearchFormSubmitState extends State<SearchFormSubmit> {
  late final SearchFormController _searchFormController;

  @override
  void initState() {
    super.initState();
    _searchFormController = DependenciesScope.of(context).searchFormController;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.paddingVertical,
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
        bottom: Dimens.of(context).paddingScreenVertical,
      ),
      child: ListenableBuilder(
        listenable: _searchFormController,
        child: SizedBox(height: 52, child: Center(child: Text("Searh"))),
        builder: (context, child) {
          return FilledButton(
            key: const ValueKey(searchFormSubmitButtonKey),
            onPressed:
                _searchFormController.valid ? _searchFormController.updateItineraryConfig : null,
            child: child,
          );
        },
      ),
    );
  }

  void _onResult() {
    if (_searchFormController.completed) {
      widget.viewModel.updateItineraryConfig.clearResult();
      context.go(Routes.results);
    }

    if (widget.viewModel.updateItineraryConfig.error) {
      widget.viewModel.updateItineraryConfig.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error while saving itinerary"),
          action: SnackBarAction(
            label: "Try again",
            onPressed: _searchFormController.updateItineraryConfig,
          ),
        ),
      );
    }
  }
}
