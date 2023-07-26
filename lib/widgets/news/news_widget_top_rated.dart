import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/domain/blocs/news_bloc/news_bloc.dart';

import 'package:moviedb/elements/circular_progress_widget.dart';
import 'package:moviedb/elements/custom_toggle_swich.dart';
import 'package:moviedb/navigation/main_navigation.dart';
import 'package:moviedb/utils/get_rating_color.dart';
import 'package:moviedb/widgets/news/news_cubit.dart';
import 'package:provider/provider.dart';

class NewsWidgetTopRated extends StatefulWidget {
  const NewsWidgetTopRated({Key? key}) : super(key: key);

  @override
  _NewsWidgetTopRatedState createState() => _NewsWidgetTopRatedState();
}

class _NewsWidgetTopRatedState extends State<NewsWidgetTopRated>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);
    final timeWindow =
        context.read<TrendingListCubit>().state.selectedTiwmeWindow;
    Future.microtask(() => context
        .read<TrendingListCubit>()
        .setupLocal(locale.languageCode, timeWindow));
  }

  void handleMediaTypeChange(String selectedMediaType) {
    this.selectedMediaType = selectedMediaType;

    context
        .read<NewsBloc>()
        .add(ToggleTopRatedMediaTypeEvent(selectedMediaType));
  }

  String selectedMediaType = 'movie';
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TrendingListCubit>();
    final selectedMediaType =
        context.select((NewsBloc bloc) => bloc.state.selectedMediaType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Rated',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                  child: ToggleButton(
                button1Label: 'Movies',
                button1Value: 'movies',
                button2Label: 'TV',
                button2Value: 'tv',
                onValueChange: handleMediaTypeChange,
                selectedValue: cubit.state.selectedMediaType,
              )),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _TopRatedHorizontalResults(
          scrollController: _scrollController,
          cubit: cubit,
          animation: _animation,
          selectedMediaType: selectedMediaType,
        ),
      ],
    );
  }
}

class _TopRatedHorizontalResults extends StatelessWidget {
  const _TopRatedHorizontalResults({
    Key? key,
    required ScrollController scrollController,
    required this.cubit,
    required Animation<double> animation,
    required this.selectedMediaType,
  })  : _scrollController = scrollController,
        _animation = animation,
        super(key: key);

  final ScrollController _scrollController;
  final TrendingListCubit cubit;
  final Animation<double> _animation;
  final String selectedMediaType;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((TrendingListCubit cubit) => cubit.state.isLoading);

    if (isLoading) {
      return const SizedBox(
        height: 600,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final topRated = selectedMediaType == 'movies'
        ? cubit.state.topRatedMovies
        : cubit.state.topRatedTVShows;

    return SizedBox(
      height: 350,
      child: Scrollbar(
        thickness: 6,
        radius: const Radius.circular(8),
        controller: _scrollController,
        thumbVisibility: true,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          reverse: false,
          scrollDirection: Axis.horizontal,
          itemCount: topRated.length,
          itemExtent: 170,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            final topRatedItem = topRated[index];
            final posterPath = topRatedItem is TopRatedMovieListRowData
                ? topRatedItem.posterPath
                : topRatedItem is TopRatedTVShowListRowData
                    ? topRatedItem.posterPath
                    : null;
            final scoreData = (topRatedItem is TopRatedMovieListRowData
                    ? topRatedItem.voteAverage
                    : topRatedItem is TopRatedTVShowListRowData
                        ? topRatedItem.voteAverage
                        : 0) *
                10;
            return FadeTransition(
              opacity: _animation,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              height: 225,
                              width: 150,
                              child: Stack(
                                children: [
                                  posterPath != null
                                      ? Image.network(
                                          ImageDownloader.imageUrl(posterPath),
                                          width: 150,
                                        )
                                      : const SizedBox.shrink(),
                                  InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        if (topRatedItem
                                            is TopRatedMovieListRowData) {
                                          _onMoviePosterTap(
                                            context,
                                            topRatedItem.id,
                                          );
                                        } else if (topRatedItem
                                            is TopRatedTVShowListRowData) {
                                          _onTVShowPosterTap(
                                            context,
                                            topRatedItem.id,
                                          );
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 0,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: RadialPercentWidget(
                              percent: scoreData / 10,
                              fillColor: const Color.fromARGB(255, 10, 23, 25),
                              lineColor: getRatingColor(scoreData * 10),
                              freeColor: const Color.fromARGB(255, 25, 54, 31),
                              lineWidth: 4,
                              child: Text(
                                scoreData.toStringAsFixed(0) + '%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: Text(
                        topRatedItem is TopRatedMovieListRowData
                            ? topRatedItem.title ?? ''
                            : topRatedItem is TopRatedTVShowListRowData
                                ? topRatedItem.name ?? ''
                                : '',
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: Text(
                        topRatedItem is TopRatedMovieListRowData
                            ? topRatedItem.releaseDate ?? ''
                            : topRatedItem is TopRatedTVShowListRowData
                                ? topRatedItem.firstAirDate ?? ''
                                : '',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String formatDate(DateTime? date) {
  return date != null ? '${date.day}.${date.month}.${date.year}' : '';
}

void _onMoviePosterTap(BuildContext context, int movieId) {
  Navigator.of(context).pushNamed(
    MainNavigationRouteNames.movieDetails,
    arguments: movieId,
  );
}

void _onTVShowPosterTap(BuildContext context, int showId) {
  Navigator.of(context).pushNamed(
    MainNavigationRouteNames.showDetails,
    arguments: showId,
  );
}
