import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/elements/circular_progress_widget.dart';
import 'package:moviedb/resources/resources.dart';
import 'package:moviedb/widgets/news/news_cubit.dart';
import 'package:provider/provider.dart';

class NewsWidgetTrandings extends StatefulWidget {
  const NewsWidgetTrandings({Key? key}) : super(key: key);

  @override
  _NewsWidgetTrandingsState createState() => _NewsWidgetTrandingsState();
}

class _NewsWidgetTrandingsState extends State<NewsWidgetTrandings> {
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.state.trending.length,
            itemExtent: 170,
            itemBuilder: (BuildContext context, int index) {
              final trending = cubit.state.trending[index];
              final posterPath = trending.posterPath;
              final scoreData = trending.voteAverage * 10;
              return Padding(
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
                            child: posterPath != null
                                ? Image.network(
                                    ImageDownloader.imageUrl(posterPath),
                                    width: 150,
                                  )
                                : const SizedBox.shrink(),
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
                              fillColor: const Color.fromARGB(255, 10, 23, 25),
                              lineColor:
                                  const Color.fromARGB(255, 37, 203, 103),
                              freeColor: const Color.fromARGB(255, 25, 54, 31),
                              lineWidth: 3,
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
                        trending.title ?? trending.name ?? '',
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: Text(
                          trending.releaseDate ?? trending.firstAirDate ?? ''),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
