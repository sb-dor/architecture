// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/colors.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/search_form/controller/search_form_controller.dart';
import 'package:flutter/material.dart';

const String removeGuestsKey = 'remove-guests';
const String addGuestsKey = 'add-guests';

/// Number of guests selection form
///
/// Users can tap the Plus and Minus icons to increase or decrease
/// the number of guests.
class SearchFormGuests extends StatefulWidget {
  const SearchFormGuests({super.key});

  @override
  State<SearchFormGuests> createState() => _SearchFormGuestsState();
}

class _SearchFormGuestsState extends State<SearchFormGuests> {
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
      ),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey1),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.paddingHorizontal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Who', style: Theme.of(context).textTheme.titleMedium),
              _QuantitySelector(_searchFormController),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector(this.searchFormController);

  final SearchFormController searchFormController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            key: const ValueKey(removeGuestsKey),
            onTap: () {
              searchFormController.guests--;
            },
            child: const Icon(
              Icons.remove_circle_outline,
              color: AppColors.grey3,
            ),
          ),
          ListenableBuilder(
            listenable: searchFormController,
            builder:
                (context, _) => Text(
                  searchFormController.guests.toString(),
                  style:
                      searchFormController.guests == 0
                          ? Theme.of(context).inputDecorationTheme.hintStyle
                          : Theme.of(context).textTheme.bodyMedium,
                ),
          ),
          InkWell(
            key: const ValueKey(addGuestsKey),
            onTap: () {
              searchFormController.guests++;
            },
            child: const Icon(Icons.add_circle_outline, color: AppColors.grey3),
          ),
        ],
      ),
    );
  }
}
