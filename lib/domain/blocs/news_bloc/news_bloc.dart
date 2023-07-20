// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/domain/entity/top_rated_movies.dart';
import 'package:moviedb/domain/entity/top_rated_tv_responce.dart';
import 'package:moviedb/domain/entity/trending_responce.dart';
import 'package:moviedb/domain/services/news_service.dart';

abstract class NewsEvent {}

class FetchInitialNewsEvent extends NewsEvent {
  final String timeWindow;

  FetchInitialNewsEvent(this.timeWindow);
}

class ToggleTrendingMoviesEvent extends NewsEvent {
  final String timeWindow;

  ToggleTrendingMoviesEvent(this.timeWindow);
}

class ToggleTopRatedMediaTypeEvent extends NewsEvent {
  final String selectedMediaType;

  ToggleTopRatedMediaTypeEvent(this.selectedMediaType);
}

class NewsState {
  final bool isLoading;
  final TrendingResponce trendinList;
  final TopRatedMovieResponce topRatedMovies;
  final TopRatedTVResponce topRatedTVShows;
  final String timeWindow;
  final String selectedMediaType;

  NewsState({
    required this.isLoading,
    required this.trendinList,
    required this.topRatedMovies,
    required this.topRatedTVShows,
    required this.timeWindow,
    required this.selectedMediaType,
  });

  NewsState.initial()
      : trendinList = TrendingResponce(
          page: 1,
          results: [],
          totalPages: 1,
          totalResults: 1,
        ),
        topRatedMovies = TopRatedMovieResponce(
          page: 1,
          movie: [],
          totalPages: 1,
          totalResults: 1,
        ),
        topRatedTVShows = TopRatedTVResponce(
          page: 1,
          tvShows: [],
          totalPages: 1,
          totalResults: 1,
        ),
        isLoading = true,
        timeWindow = 'day',
        selectedMediaType = 'movies';

  @override
  bool operator ==(covariant NewsState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        other.trendinList == trendinList &&
        other.topRatedMovies == topRatedMovies &&
        other.topRatedTVShows == topRatedTVShows &&
        other.timeWindow == timeWindow &&
        other.selectedMediaType == selectedMediaType;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        trendinList.hashCode ^
        topRatedMovies.hashCode ^
        topRatedTVShows.hashCode ^
        timeWindow.hashCode ^
        selectedMediaType.hashCode;
  }

  NewsState copyWith({
    bool? isLoading,
    TrendingResponce? trendinList,
    TopRatedMovieResponce? topRatedMovies,
    TopRatedTVResponce? topRatedTVShows,
    String? timeWindow,
    String? selectedMediaType,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      trendinList: trendinList ?? this.trendinList,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedTVShows: topRatedTVShows ?? this.topRatedTVShows,
      timeWindow: timeWindow ?? this.timeWindow,
      selectedMediaType: selectedMediaType ?? this.selectedMediaType,
    );
  }
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService _newsService;

  NewsBloc(NewsState initialState, this._newsService) : super(initialState) {
    on<FetchInitialNewsEvent>(_fetchInitialNewsEvent);
    on<ToggleTrendingMoviesEvent>(_fetchToggleTrandingNewsEvent);
    on<ToggleTopRatedMediaTypeEvent>(_fetchToggleTopRatedMediaTypeEvent);
  }

  void _fetchInitialNewsEvent(
    FetchInitialNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final fetchedTrandingMovies =
          await _newsService.trendingAll(event.timeWindow);
      final fetchedTopRatedMovies = await _newsService.topRatedMovies();
      final fetchedTopRatedTVshows = await _newsService.topRatedTVShow();
      emit(state.copyWith(
          trendinList: fetchedTrandingMovies,
          topRatedMovies: fetchedTopRatedMovies,
          topRatedTVShows: fetchedTopRatedTVshows,
          isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _fetchToggleTrandingNewsEvent(
    ToggleTrendingMoviesEvent event,
    Emitter<NewsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final fetchedTrandingMovies =
          await _newsService.trendingAll(event.timeWindow);
      emit(
          state.copyWith(trendinList: fetchedTrandingMovies, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _fetchToggleTopRatedMediaTypeEvent(
    ToggleTopRatedMediaTypeEvent event,
    Emitter<NewsState> emit,
  ) async {
    try {
      print('Fetching top rated ${event.selectedMediaType}...'); // Debug log
      emit(state.copyWith(
          isLoading: true, selectedMediaType: event.selectedMediaType));
      if (event.selectedMediaType == 'movies') {
        final fetchedTopRatedMovies = await _newsService.topRatedMovies();
        emit(state.copyWith(
          topRatedMovies: fetchedTopRatedMovies,
          isLoading: false,
        ));
      } else if (event.selectedMediaType == 'tv') {
        final fetchedTopRatedTVShows = await _newsService.topRatedTVShow();
        emit(state.copyWith(
          topRatedTVShows: fetchedTopRatedTVShows,
          isLoading: false,
        ));
      }
      print(
          'Top rated ${event.selectedMediaType} fetched successfully.'); // Debug log
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print(
          'Error fetching top rated ${event.selectedMediaType}: $e'); // Debug log
    }
  }
}
