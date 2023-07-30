// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/domain/blocs/search_bloc/search_bloc.dart';
import 'package:moviedb/navigation/navigation_helper.dart';

class SearchResult extends StatefulWidget {
  final String searchQuery;
  const SearchResult({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);
    final searchBloc = context.read<SearchBloc>();
    searchBloc
        .add(FetchSearchResultsEvent(locale.languageCode, widget.searchQuery));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            const _MovieSearchResultListWidget(),
            _SearchWidget(),
          ],
        ),
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  _SearchWidget({
    Key? key,
  }) : super(key: key);

  Timer? _debouncer;

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    const _debounceDuration = Duration(milliseconds: 500);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: (searchQuery) {
          _debouncer?.cancel();
          _debouncer = Timer(_debounceDuration, () {
            searchBloc.add(FetchSearchResultsEvent(
                Localizations.localeOf(context).languageCode, searchQuery));
          });
        },
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

class _MovieSearchResultListWidget extends StatelessWidget {
  const _MovieSearchResultListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final movieSearchResults = state.movieSearchResultContainer.movies;
        return ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(top: 70),
          itemCount: movieSearchResults.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            return _MovieListRowWidget(
              index: index,
            );
          },
        );
      },
    );
  }
}

class _MovieListRowWidget extends StatelessWidget {
  final int index;
  const _MovieListRowWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.watch<SearchBloc>();
    final movie = searchBloc.state.movieSearchResultContainer.movies[index];
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
                        movie.releaseDate != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(movie.releaseDate!)
                            : 'N/A',
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
              onTap: () =>
                  NavigationHelper.navigateToMovieDetails(context, movie.id),
            ),
          )
        ],
      ),
    );
  }
}
