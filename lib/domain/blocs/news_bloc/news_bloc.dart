// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

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

class UpdateTrendingListEvent extends NewsEvent {}

class UpdateLatestTrailersEvent extends NewsEvent {}

class UpdateFreeToWatchEvent extends NewsEvent {}

class UpdateWatsPopularEvent extends NewsEvent {}

class NewsState {
  final bool isLoading;
  final TrendingResponce trendinList;
  final String timeWindow;

  NewsState({
    required this.isLoading,
    required this.trendinList,
    required this.timeWindow,
  });

  NewsState.initial()
      : trendinList = TrendingResponce(
          page: 1,
          results: [],
          totalPages: 1,
          totalResults: 1,
        ),
        isLoading = true,
        timeWindow = 'day';

  NewsState copyWith({
    bool? isLoading,
    TrendingResponce? trendinList,
    String? timeWindow,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      trendinList: trendinList ?? this.trendinList,
      timeWindow: timeWindow ?? this.timeWindow,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^ trendinList.hashCode ^ timeWindow.hashCode;
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService _newsService;

  NewsBloc(NewsState initialState, this._newsService) : super(initialState) {
    on<FetchInitialNewsEvent>(_fetchInitialNewsEvent);
    on<ToggleTrendingMoviesEvent>(_fetchToggleTrandingNewsEvent);
  }

  void _fetchInitialNewsEvent(
    FetchInitialNewsEvent event,
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
}
