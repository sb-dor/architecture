import 'package:architectures/models/activity.dart';
import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/activities/controllers/activities_controller.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:flutter/material.dart';
import 'activities_header_widget.dart';
import 'activities_list.dart';
import 'activities_title_widget.dart';

const String confirmButtonKey = 'confirm-button';

class ActivitiesWidget extends StatefulWidget {
  const ActivitiesWidget({super.key});

  @override
  State<ActivitiesWidget> createState() => _ActivitiesWidgetState();
}

class _ActivitiesWidgetState extends State<ActivitiesWidget> {
  late final ActivitiesController _activitiesController;

  @override
  void initState() {
    super.initState();
    _activitiesController = DependenciesScope.of(context).activitiesController;
    _activitiesController.loadActivities();
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
          listenable: _activitiesController,
          builder: (context, child) {
            if (_activitiesController.completed) {
              return child!;
            }
            return Column(
              children: [
                const ActivitiesHeader(),
                if (_activitiesController.loading)
                  const Expanded(child: Center(child: CircularProgressIndicator())),
              ],
            );
          },
          child: ListenableBuilder(
            listenable: _activitiesController,
            builder: (context, child) {
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: ActivitiesHeader()),
                        ActivitiesTitle(
                          activitiesController: _activitiesController,
                          activityTimeOfDay: ActivityTimeOfDay.daytime,
                        ),
                        ActivitiesList(
                          activitiesController: _activitiesController,
                          activityTimeOfDay: ActivityTimeOfDay.daytime,
                        ),
                        ActivitiesTitle(
                          activitiesController: _activitiesController,
                          activityTimeOfDay: ActivityTimeOfDay.evening,
                        ),
                        ActivitiesList(
                          activitiesController: _activitiesController,
                          activityTimeOfDay: ActivityTimeOfDay.evening,
                        ),
                      ],
                    ),
                  ),
                  _BottomArea(activitiesController: _activitiesController),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BottomArea extends StatelessWidget {
  const _BottomArea({required this.activitiesController});

  final ActivitiesController activitiesController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Material(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimens.of(context).paddingScreenHorizontal,
            right: Dimens.of(context).paddingScreenVertical,
            top: Dimens.paddingVertical,
            bottom: Dimens.of(context).paddingScreenVertical,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${activitiesController.selectedActivities.length} selected",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              FilledButton(
                key: const Key(confirmButtonKey),
                onPressed: () {
                  if (activitiesController.selectedActivities.isNotEmpty) {
                    activitiesController.saveActivities();
                  }
                },
                child: Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
