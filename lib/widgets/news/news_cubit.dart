// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:moviedb/domain/blocs/news_bloc/news_bloc.dart';
import 'package:moviedb/domain/entity/movie.dart';
import 'package:moviedb/domain/entity/trending.dart';
import 'package:moviedb/domain/entity/tv_show.dart';
import 'package:moviedb/domain/entity/upcoming_movies.dart';

class TrendingListRowData {
  final int id;
  final String? posterPath;
  final String? title;
  final String? name;
  final String? releaseDate;
  final String? firstAirDate;
  final String mediaType;
  final double voteAverage;

  TrendingListRowData({
    required this.id,
    this.posterPath,
    required this.title,
    required this.name,
    required this.releaseDate,
    required this.firstAirDate,
    required this.mediaType,
    required this.voteAverage,
  });
}

class UpcomingMovieListRowData {
  final int id;
  final String? backDropPath;
  final String? title;
  final String? releaseDate;
  UpcomingMovieListRowData({
    required this.id,
    this.backDropPath,
    this.title,
    this.releaseDate,
  });
}

class TopRatedMovieListRowData {
  final int id;
  final String? posterPath;
  final String? title;
  final String? releaseDate;
  final double voteAverage;

  TopRatedMovieListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.voteAverage,
  });
}

class TopRatedTVShowListRowData {
  final int id;
  final String? posterPath;
  final String? name;
  final String? firstAirDate;
  final double voteAverage;

  TopRatedTVShowListRowData({
    required this.id,
    this.posterPath,
    required this.name,
    required this.firstAirDate,
    required this.voteAverage,
  });
}

class TrendingListCubitState {
  final List<TrendingListRowData> trending;
  final List<UpcomingMovieListRowData> upcomingMovieTrailers;
  final List<TopRatedMovieListRowData> topRatedMovies;
  final List<TopRatedTVShowListRowData> topRatedTVShows;
  final String localeTag;
  final bool isLoading;
  final String selectedTiwmeWindow;
  final String selectedMediaType;
  TrendingListCubitState({
    required this.trending,
    required this.upcomingMovieTrailers,
    required this.topRatedMovies,
    required this.topRatedTVShows,
    required this.localeTag,
    required this.isLoading,
    required this.selectedTiwmeWindow,
    required this.selectedMediaType,
  });

  @override
  bool operator ==(covariant TrendingListCubitState other) {
    if (identical(this, other)) return true;

    return listEquals(other.trending, trending) &&
        listEquals(other.upcomingMovieTrailers, upcomingMovieTrailers) &&
        listEquals(other.topRatedMovies, topRatedMovies) &&
        listEquals(other.topRatedTVShows, topRatedTVShows) &&
        other.localeTag == localeTag &&
        other.isLoading == isLoading &&
        other.selectedTiwmeWindow == selectedTiwmeWindow &&
        other.selectedMediaType == selectedMediaType;
  }

  @override
  int get hashCode {
    return trending.hashCode ^
        upcomingMovieTrailers.hashCode ^
        topRatedMovies.hashCode ^
        topRatedTVShows.hashCode ^
        localeTag.hashCode ^
        isLoading.hashCode ^
        selectedTiwmeWindow.hashCode ^
        selectedMediaType.hashCode;
  }

  TrendingListCubitState copyWith({
    List<TrendingListRowData>? trending,
    List<UpcomingMovieListRowData>? upcomingMovieTrailers,
    List<TopRatedMovieListRowData>? topRatedMovies,
    List<TopRatedTVShowListRowData>? topRatedTVShows,
    String? localeTag,
    bool? isLoading,
    String? selectedTiwmeWindow,
    String? selectedMediaType,
  }) {
    return TrendingListCubitState(
      trending: trending ?? this.trending,
      upcomingMovieTrailers:
          upcomingMovieTrailers ?? this.upcomingMovieTrailers,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedTVShows: topRatedTVShows ?? this.topRatedTVShows,
      localeTag: localeTag ?? this.localeTag,
      isLoading: isLoading ?? this.isLoading,
      selectedTiwmeWindow: selectedTiwmeWindow ?? this.selectedTiwmeWindow,
      selectedMediaType: selectedMediaType ?? this.selectedMediaType,
    );
  }
}

class TrendingListCubit extends Cubit<TrendingListCubitState> {
  final NewsBloc newsBloc;
  late DateFormat _dateFormat;

  late final StreamSubscription<NewsState> newsListBlocSubscription;
  TrendingListCubit({required this.newsBloc})
      : super(TrendingListCubitState(
            trending: const <TrendingListRowData>[],
            upcomingMovieTrailers: const <UpcomingMovieListRowData>[],
            topRatedMovies: const <TopRatedMovieListRowData>[],
            topRatedTVShows: const <TopRatedTVShowListRowData>[],
            localeTag: '',
            isLoading: true,
            selectedTiwmeWindow: '',
            selectedMediaType: '')) {
    Future.microtask(() {
      _onState(newsBloc.state);
      newsListBlocSubscription = newsBloc.stream.listen(_onState);
    });
  }
  void _onState(NewsState state) {
    final trending =
        state.trendinList.results.map(_makeTrendingRowData).toList();
    final upcomigMovieTrailers = state.upcomingMovies.results
        .map(_makeUpcomingMoviesTrailersRowData)
        .toList();
    final topRatedMovies =
        state.topRatedMovies.movie.map(_makeTopRatedMoviesRowData).toList();
    final topRatedTVShows =
        state.topRatedTVShows.tvShows.map(_makeTopRatedTVShowsRowData).toList();
    final newState = this.state.copyWith(
        trending: trending,
        upcomingMovieTrailers: upcomigMovieTrailers,
        topRatedMovies: topRatedMovies,
        topRatedTVShows: topRatedTVShows,
        isLoading: state.isLoading);

    emit(newState);
  }

  @override
  Future<void> close() {
    newsListBlocSubscription.cancel();
    return super.close();
  }

  void setupLocal(String localeTag, String timeWindow) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    newsBloc.add(FetchInitialNewsEvent(timeWindow));
  }

  TrendingListRowData _makeTrendingRowData(Trending trending) {
    final releaseDate = trending.releaseDate;
    final firstAirDate = trending.firstAirDate;
    final airDateTitle = trending.mediaType == 'tv' && firstAirDate != null
        ? _dateFormat.format(firstAirDate)
        : null;
    final releaseDateTitle =
        trending.mediaType == 'movie' && releaseDate != null
            ? _dateFormat.format(releaseDate)
            : null;

    return TrendingListRowData(
      id: trending.id,
      posterPath: trending.posterPath,
      releaseDate: releaseDateTitle,
      firstAirDate: airDateTitle,
      mediaType: trending.mediaType,
      voteAverage: trending.voteAverage,
      title: trending.title,
      name: trending.name,
    );
  }

  UpcomingMovieListRowData _makeUpcomingMoviesTrailersRowData(Results movie) {
    return UpcomingMovieListRowData(
      id: movie.id,
      backDropPath: movie.backdropPath,
      title: movie.title,
      releaseDate: movie.releaseDate,
    );
  }

  TopRatedMovieListRowData _makeTopRatedMoviesRowData(Movie movie) {
    final releaseDate = movie.releaseDate;
    final releaseDateTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';

    return TopRatedMovieListRowData(
      id: movie.id,
      posterPath: movie.posterPath,
      releaseDate: releaseDateTitle,
      voteAverage: movie.voteAverage,
      title: movie.title,
    );
  }

  TopRatedTVShowListRowData _makeTopRatedTVShowsRowData(TvShow show) {
    final firstairDate = show.firstairDate;
    final firstairDateTitle =
        firstairDate != null ? _dateFormat.format(firstairDate) : '';

    return TopRatedTVShowListRowData(
      id: show.id,
      posterPath: show.posterPath,
      firstAirDate: firstairDateTitle,
      voteAverage: show.voteAverage,
      name: show.name,
    );
  }
}
