import 'package:architectures/models/continent.dart';
import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/colors.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/common/ui/error_indicator.dart';
import 'package:architectures/ui/search_form/controller/search_form_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFormContinentWidget extends StatefulWidget {
  const SearchFormContinentWidget({super.key});

  @override
  State<SearchFormContinentWidget> createState() =>
      _SearchFormContinentWidgetState();
}

class _SearchFormContinentWidgetState extends State<SearchFormContinentWidget> {
  late final SearchFormController _searchFormController;

  @override
  void initState() {
    super.initState();
    _searchFormController = DependenciesScope.of(context).searchFormController;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListenableBuilder(
        listenable: _searchFormController,
        builder: (context, child) {
          if (_searchFormController.running) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_searchFormController.error) {
            return Center(
              child: ErrorIndicator(
                title: "Error while loading continents",
                label: "Try again",
                onPressed: () => _searchFormController.load(),
              ),
            );
          }
          return child!;
        },
        child: ListenableBuilder(
          listenable: _searchFormController,
          builder: (context, child) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _searchFormController.continents.length,
              padding: Dimens.of(context).edgeInsetsScreenHorizontal,
              itemBuilder: (BuildContext context, int index) {
                final Continent(:imageUrl, :name) =
                    _searchFormController.continents[index];
                return _CarouselItem(
                  key: ValueKey("continent_key_name_$name"),
                  imageUrl: imageUrl,
                  name: name,
                  searchFormController: _searchFormController,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 8);
              },
            );
          },
        ),
      ),
    );
  }
}

class _CarouselItem extends StatelessWidget {
  const _CarouselItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.searchFormController,
  });

  final String imageUrl;
  final String name;
  final SearchFormController searchFormController;

  bool _selected() =>
      searchFormController.selectedContinent == null ||
      searchFormController.selectedContinent == name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                // NOTE: Getting "invalid image data" error for some of the images
                // e.g. https://rstr.in/google/tripedia/jlbgFDrSUVE
                return const DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.grey3),
                  child: SizedBox(width: 140, height: 140),
                );
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white1,
                  ),
                ),
              ),
            ),
            // Overlay when other continent is selected
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _selected() ? 0 : 0.7,
                duration: kThemeChangeDuration,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    // Support dark-mode
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            // Handle taps
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (searchFormController.selectedContinent == name) {
                      searchFormController.selectedContinent = null;
                    } else {
                      searchFormController.selectedContinent = name;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
