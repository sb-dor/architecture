import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/common/ui/app_search_bar.dart';
import 'package:architectures/ui/common/ui/error_indicator.dart';
import 'package:architectures/ui/results/controllers/result_controller.dart';
import 'package:architectures/ui/results/widgets/result_card_widget.dart';
import 'package:flutter/material.dart';

class ResultWidget extends StatefulWidget {
  const ResultWidget({super.key});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  late final ResultController _resultController;

  @override
  void initState() {
    super.initState();
    _resultController = DependenciesScope.of(context).resultController;
    // widget.viewModel.updateItineraryConfig.addListener(_onResult);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        if (!didPop) Navigator.pop(context);
      },
      child: Scaffold(
        body: ListenableBuilder(
          listenable: _resultController,
          builder: (context, child) {
            if (widget.viewModel.search.completed) {
              return child!;
            }
            return Column(
              children: [
                _AppSearchBar(widget: widget),
                if (widget.viewModel.search.running)
                  const Expanded(child: Center(child: CircularProgressIndicator())),
                if (widget.viewModel.search.error)
                  Expanded(
                    child: Center(
                      child: ErrorIndicator(
                        title: "Error while loading destinations",
                        label: "Try again",
                        onPressed: _resultController.search,
                      ),
                    ),
                  ),
              ],
            );
          },
          child: ListenableBuilder(
            listenable: _resultController,
            builder: (context, child) {
              return Padding(
                padding: Dimens.of(context).edgeInsetsScreenHorizontal,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _AppSearchBar(resultController: _resultController)),
                    _Grid(resultController: _resultController),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.updateItineraryConfig.completed) {
      widget.viewModel.updateItineraryConfig.clearResult();
      context.go(Routes.activities);
    }

    if (widget.viewModel.updateItineraryConfig.error) {
      widget.viewModel.updateItineraryConfig.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.of(context).errorWhileSavingItinerary)),
      );
    }
  }
}

class _AppSearchBar extends StatelessWidget {
  const _AppSearchBar({required this.resultController});

  final ResultController resultController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          top: Dimens.of(context).paddingScreenVertical,
          bottom: Dimens.mobile.paddingScreenVertical,
        ),
        child: AppSearchBar(
          config: resultController.config,
          onTap: () {
            // Navigate to SearchFormScreen and edit search
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.resultController});

  final ResultController resultController;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 182 / 222,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final destination = resultController.destinations[index];
        return ResultCardWidget(
          key: ValueKey(destination.ref),
          destination: destination,
          onTap: () {
            resultController.updateItineraryConfig(destination.ref);
          },
        );
      }, childCount: resultController.destinations.length),
    );
  }
}
