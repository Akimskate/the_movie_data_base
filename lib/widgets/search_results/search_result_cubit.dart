// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/blocs/search_bloc/search_bloc.dart';
import 'package:moviedb/domain/entity/movie.dart';
import 'package:moviedb/domain/entity/tv_show.dart';

class SearchResultMovieListRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  SearchResultMovieListRowData(
      {required this.id,
      required this.posterPath,
      required this.title,
      required this.releaseDate,
      required this.overview});
}

class SearchResultTVShowListRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  SearchResultTVShowListRowData(
      {required this.id,
      required this.posterPath,
      required this.title,
      required this.releaseDate,
      required this.overview});
}

class SearchResultListCubitState {
  final List<SearchResultMovieListRowData> moviesSearchResult;
  final List<SearchResultTVShowListRowData> showSearchResult;
  final String localeTag;

  SearchResultListCubitState({
    required this.moviesSearchResult,
    required this.showSearchResult,
    required this.localeTag,
  });

  @override
  bool operator ==(covariant SearchResultListCubitState other) {
    if (identical(this, other)) return true;

    return listEquals(other.moviesSearchResult, moviesSearchResult) &&
        listEquals(other.showSearchResult, showSearchResult) &&
        other.localeTag == localeTag;
  }

  @override
  int get hashCode =>
      moviesSearchResult.hashCode ^
      showSearchResult.hashCode ^
      localeTag.hashCode;

  SearchResultListCubitState copyWith({
    List<SearchResultMovieListRowData>? moviesSearchResult,
    List<SearchResultTVShowListRowData>? showSearchResult,
    String? localeTag,
  }) {
    return SearchResultListCubitState(
      moviesSearchResult: moviesSearchResult ?? this.moviesSearchResult,
      showSearchResult: showSearchResult ?? this.showSearchResult,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}

class SearchResultListCubit extends Cubit<SearchResultListCubitState> {
  final SearchBloc searchResultBloc;
  late DateFormat _dateFormat;
  Timer? searchDebounce;
  late final StreamSubscription<SearchState> searchResultBlocSubscription;
  SearchResultListCubit({
    required this.searchResultBloc,
  }) : super(
          SearchResultListCubitState(
            moviesSearchResult: const <SearchResultMovieListRowData>[],
            showSearchResult: const <SearchResultTVShowListRowData>[],
            localeTag: "",
          ),
        ) {
    Future.microtask(() {
      _onState(searchResultBloc.state);
      searchResultBlocSubscription = searchResultBloc.stream.listen(_onState);
    });
  }
  void _onState(SearchState state) {
    final movies = state.movieSearchResultContainer.movies
        .map(_makeSearchResultMovieRowData)
        .toList();
    final shows = state.showSearchResultContainer.tvShows
        .map(_makeSearchResultShowRowData)
        .toList();
    final newState = this
        .state
        .copyWith(moviesSearchResult: movies, showSearchResult: shows);
    emit(newState);
  }

  void setupLocal(String localeTag, String searchQuerry) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    searchResultBloc.add(FetchSearchResultsEvent(
      locale: state.localeTag,
      querry: searchQuerry,
    ));
  }

  void showedMovieAtIndex(int index) {
    if (index < state.moviesSearchResult.length - 1) return;
    if (index < state.showSearchResult.length - 1) return;
    searchResultBloc.add(
      SearchResultListEventLoadNextPage(locale: state.localeTag),
    );
  }

  void searchMovieAndShow(String searchQuery) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      searchResultBloc.add(
        FetchSearchResultsEvent(
          locale: state.localeTag,
          querry: searchQuery,
        ),
      );
      searchResultBloc.add(
        SearchResultListEventLoadNextPage(locale: state.localeTag),
      );
    });
  }

  @override
  Future<void> close() {
    searchResultBlocSubscription.cancel();
    return super.close();
  }

  SearchResultMovieListRowData _makeSearchResultMovieRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDataTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';

    return SearchResultMovieListRowData(
      id: movie.id,
      overview: movie.overview,
      posterPath: movie.posterPath,
      releaseDate: releaseDataTitle,
      title: movie.title,
    );
  }

  SearchResultTVShowListRowData _makeSearchResultShowRowData(TvShow tvShow) {
    final releaseDate = tvShow.firstairDate;
    final releaseDataTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';

    return SearchResultTVShowListRowData(
      id: tvShow.id,
      overview: tvShow.overview,
      posterPath: tvShow.posterPath,
      releaseDate: releaseDataTitle,
      title: tvShow.name,
    );
  }
}
