import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/navigation/main_navigation.dart';
import 'package:moviedb/widgets/movie_list/movie_list_cubit.dart';

import 'package:provider/provider.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);
    context.read<MovieListCubit>().setupLocal(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _MovieListWidget(),
        _SearchWidget(),
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieListCubit>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: cubit.searchMovie,
        decoration: InputDecoration(
          labelText: 'Search',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieListCubit>();
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(top: 70),
      itemCount: cubit.state.movies.length,
      itemExtent: 163,
      itemBuilder: (BuildContext context, int index) {
        cubit.showedMovieAtIndex(index);

        return _MovieLisrRowWidget(
          index: index,
        );
      },
    );
  }
}

class _MovieLisrRowWidget extends StatelessWidget {
  final int index;
  const _MovieLisrRowWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovieListCubit>();
    final movie = cubit.state.movies[index];
    final posterPath = movie.posterPath;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 25,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                posterPath != null
                    ? Image.network(
                        ImageDownloader.imageUrl(posterPath),
                        width: 95,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _onMovieTap(context, movie.id),
            ),
          )
        ],
      ),
    );
  }

  void _onMovieTap(BuildContext context, int movieId) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: movieId,
    );
  }
}
