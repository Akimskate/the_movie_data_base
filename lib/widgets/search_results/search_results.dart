import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/domain/blocs/search_bloc/search_bloc.dart';
import 'package:moviedb/navigation/navigation_helper.dart';
import 'package:moviedb/widgets/search_results/search_result_cubit.dart';

class SearchResult extends StatefulWidget {
  final String searchQuery;
  const SearchResult({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);
    context
        .read<SearchResultListCubit>()
        .setupLocal(locale.languageCode, widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.watch<SearchBloc>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Results'),
          centerTitle: true,
        ),
        body: Column(children: [
          TabBar(controller: _tabController, tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Movies',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  IntrinsicWidth(
                    child: Container(
                      alignment: Alignment.center,
                      height: 27,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                        child: Text(
                          searchBloc
                              .state.movieSearchResultContainer.totalResults
                              .toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'TV Shows',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    IntrinsicWidth(
                      child: Container(
                        alignment: Alignment.center,
                        height: 27,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                          child: Text(
                            searchBloc
                                .state.showSearchResultContainer.totalResults
                                .toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _MovieSearchResultListWidget(),
                _ShowSearchResultListWidget(),
              ],
            ),
          ),
        ]));
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer? _debouncer;
    final searchBloc = context.watch<SearchBloc>();
    const _debounceDuration = Duration(milliseconds: 500);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: (searchQuery) {
          _debouncer?.cancel();
          if (searchQuery.isNotEmpty) {
            _debouncer = Timer(_debounceDuration, () {
              searchBloc.add(FetchSearchResultsEvent(
                locale: Localizations.localeOf(context).languageCode,
                querry: searchQuery,
              ));
            });
          } else {
            return;
          }
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
    final searchBloc = context.watch<SearchBloc>();
    final cubit = context.watch<SearchResultListCubit>();
    final movieSearchResults = cubit.state.moviesSearchResult;
    return Stack(children: [
      ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(top: 70),
        itemCount: movieSearchResults.length,
        itemExtent: 163,
        itemBuilder: (BuildContext context, int index) {
          if (index == movieSearchResults.length - 3) {
            searchBloc.add(SearchResultListEventLoadNextPage(
                locale: Localizations.localeOf(context).languageCode));
          }
          return _MovieListRowWidget(
            index: index,
          );
        },
      ),
      const _SearchWidget(),
    ]);
  }
}

class _ShowSearchResultListWidget extends StatelessWidget {
  const _ShowSearchResultListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.watch<SearchBloc>();
    final cubit = context.watch<SearchResultListCubit>();
    final showSearchResults = cubit.state.showSearchResult;
    return Stack(children: [
      ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(top: 70),
        itemCount: showSearchResults.length,
        itemExtent: 163,
        itemBuilder: (BuildContext context, int index) {
          if (index == showSearchResults.length - 3) {
            searchBloc.add(SearchResultListEventLoadNextPage(
                locale: Localizations.localeOf(context).languageCode));
          }
          return _ShowListRowWidget(
            index: index,
          );
        },
      ),
      const _SearchWidget(),
    ]);
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
    final cubit = context.watch<SearchResultListCubit>();
    final movie = cubit.state.moviesSearchResult[index];
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
              onTap: () =>
                  NavigationHelper.navigateToMovieDetails(context, movie.id),
            ),
          )
        ],
      ),
    );
  }
}

class _ShowListRowWidget extends StatelessWidget {
  final int index;
  const _ShowListRowWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchResultListCubit>();
    final show = cubit.state.showSearchResult[index];
    final posterPath = show.posterPath;
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
                        show.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        show.releaseDate,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        show.overview,
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
                  NavigationHelper.navigateToShowDetails(context, show.id),
            ),
          )
        ],
      ),
    );
  }
}
