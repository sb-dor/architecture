import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/common/ui/app_search_bar.dart';
import 'package:architectures/ui/search_from/controller/search_form_controller.dart';
import 'package:architectures/ui/search_from/widgets/search_form_continent_widget.dart';
import 'package:architectures/ui/search_from/widgets/search_form_guests.dart';
import 'package:architectures/ui/search_from/widgets/search_form_submit.dart';
import 'package:flutter/material.dart';

import 'search_form_date_widget.dart';

class SearchFormWidget extends StatefulWidget {
  const SearchFormWidget({super.key});

  @override
  State<SearchFormWidget> createState() => _SearchFormWidgetState();
}

class _SearchFormWidgetState extends State<SearchFormWidget> {
  late final SearchFormController _searchFormController;

  @override
  void initState() {
    super.initState();
    _searchFormController = DependenciesScope.of(context).searchFormController;
    _searchFormController.loadContinents();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        if (!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  top: Dimens.of(context).paddingScreenVertical,
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                  bottom: Dimens.paddingVertical,
                ),
                child: const AppSearchBar(),
              ),
            ),
            SearchFormContinentWidget(),
            SearchFormDateWidget(),
            SearchFormGuests(),
            const Spacer(),
            SearchFormSubmit(),
          ],
        ),
      ),
    );
  }
}
