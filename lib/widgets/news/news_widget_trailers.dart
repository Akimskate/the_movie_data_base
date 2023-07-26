import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/domain/api_client/movie_api_client.dart';
import 'package:moviedb/navigation/main_navigation.dart';
import 'package:moviedb/navigation/navigation_helper.dart';
import 'package:moviedb/resources/resources.dart';
import 'package:moviedb/widgets/news/news_cubit.dart';

class NewsWidgetTrailers extends StatelessWidget {
  const NewsWidgetTrailers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TrendingListCubit>();
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          colorFilter:
              ColorFilter.mode(Colors.blueGrey.shade700, BlendMode.modulate),
          image: const AssetImage(AppImages.upcomingTrailersBackGround),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Trailers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.state.upcomingMovieTrailers.length,
                  itemExtent: constraints.maxWidth * 1,
                  itemBuilder: (BuildContext context, int index) {
                    final upcomingMovieItem =
                        cubit.state.upcomingMovieTrailers[index];
                    final backdroPath = upcomingMovieItem.backDropPath;
                    final title = upcomingMovieItem.title;
                    //final releaseDate = upcomingMovieItem.releaseDate;

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: InkWell(
                                  onTap: () {
                                    NavigationHelper.navigateToMovieTrailer(
                                        context, upcomingMovieItem.id);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        backdroPath != null
                                            ? Image.network(
                                                ImageDownloader.imageUrl(
                                                    backdroPath),
                                                width: 350,
                                              )
                                            : const SizedBox.shrink(),
                                        const DecoratedBox(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 20,
                                                  spreadRadius: -20),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 80,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.more_horiz),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            child: Text(
                              title ?? '',
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              NavigationHelper.navigateToMovieDetails(
                                  context, upcomingMovieItem.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
