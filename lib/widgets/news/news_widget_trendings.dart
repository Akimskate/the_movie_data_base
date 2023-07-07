import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/domain/blocs/news_bloc/news_bloc.dart';
import 'package:moviedb/elements/circular_progress_widget.dart';
import 'package:moviedb/widgets/news/news_cubit.dart';
import 'package:provider/provider.dart';

class NewsWidgetTrandings extends StatefulWidget {
  const NewsWidgetTrandings({Key? key}) : super(key: key);

  @override
  _NewsWidgetTrandingsState createState() => _NewsWidgetTrandingsState();
}

Color getRatingColor(double rating) {
  if (rating >= 65) {
    return Colors.green;
  } else if (rating >= 30) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

class _NewsWidgetTrandingsState extends State<NewsWidgetTrandings>
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
    Future.microtask(() =>
        context.read<TrendingListCubit>().setupLocal(locale.languageCode));
  }

  final _category = 'today';
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TrendingListCubit>();
    final isLoading =
        context.select((TrendingListCubit cubit) => cubit.state.isLoading);

    if (isLoading) {
      return const SizedBox(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              DropdownButton<String>(
                value: _category,
                onChanged: (category) {},
                items: const [
                  DropdownMenuItem(value: 'today', child: Text('Today')),
                  DropdownMenuItem(value: 'week', child: Text('This Week')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
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
              itemCount: cubit.state.trending.length,
              itemExtent: 170,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                final trending = cubit.state.trending[index];
                final posterPath = trending.posterPath;
                final scoreData = trending.voteAverage * 10;
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
                                child: Container(
                                    height: 225,
                                    width: 150,
                                    child: posterPath != null
                                        ? Image.network(
                                            ImageDownloader.imageUrl(
                                                posterPath),
                                            width: 150,
                                          )
                                        : const SizedBox.shrink()),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              bottom: 0,
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: RadialPercentWidget(
                                  percent: trending.voteAverage / 10,
                                  fillColor:
                                      const Color.fromARGB(255, 10, 23, 25),
                                  lineColor:
                                      getRatingColor(trending.voteAverage * 10),
                                  freeColor:
                                      const Color.fromARGB(255, 25, 54, 31),
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
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: Text(
                            trending.title ?? trending.name ?? '',
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: Text(trending.releaseDate ??
                              trending.firstAirDate ??
                              ''),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
