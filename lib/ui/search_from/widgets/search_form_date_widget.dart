import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/colors.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/search_from/controller/search_form_controller.dart';
import 'package:architectures/utils/date_format_start_end.dart';
import 'package:flutter/material.dart';

class SearchFormDateWidget extends StatefulWidget {
  const SearchFormDateWidget({super.key});

  @override
  State<SearchFormDateWidget> createState() => _SearchFormDateWidgetState();
}

class _SearchFormDateWidgetState extends State<SearchFormDateWidget> {
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          ).then((dateRange) => _searchFormController.dateRange = dateRange);
        },
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey1),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("When", style: Theme.of(context).textTheme.titleMedium),
                ListenableBuilder(
                  listenable: _searchFormController,
                  builder: (context, _) {
                    final dateRange = _searchFormController.dateRange;
                    if (dateRange != null) {
                      return Text(
                        dateFormatStartEnd(dateRange),
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
                    } else {
                      return Text(
                        "Add Dates",
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
