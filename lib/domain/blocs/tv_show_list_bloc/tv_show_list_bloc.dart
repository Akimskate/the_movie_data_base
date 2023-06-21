import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/show_api_client.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';
import 'package:moviedb/domain/entity/tv_show.dart';

abstract class TvShowListEvent {}

class TVShowListEventLoadNextPageEvent extends TvShowListEvent {
  final String locale;

  TVShowListEventLoadNextPageEvent({
    required this.locale,
  });
}

class TVShowListEventLoadResetEvent extends TvShowListEvent {
  final String locale;

  TVShowListEventLoadResetEvent({
    required this.locale,
  });
}

class TVShowListEventLoadSearchMovieEvent extends TvShowListEvent {
  final String querry;
  final String locale;

  TVShowListEventLoadSearchMovieEvent(
    this.querry,
    this.locale,
  );
}

class TVShowListContainer {
  final List<TvShow> shows;
  final int currentPage;
  final int totalPage;

  bool get isComplete => currentPage >= totalPage;

  const TVShowListContainer.initial()
      : shows = const <TvShow>[],
        currentPage = 0,
        totalPage = 1;

  TVShowListContainer({
    required this.shows,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVShowListContainer &&
          runtimeType == other.runtimeType &&
          shows == other.shows &&
          currentPage == other.currentPage &&
          totalPage == other.totalPage;

  @override
  int get hashCode =>
      shows.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;

  TVShowListContainer copyWith({
    List<TvShow>? shows,
    int? currentPage,
    int? totalPage,
  }) {
    return TVShowListContainer(
      shows: shows ?? this.shows,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}

class TVShowListState {
  final TVShowListContainer popularTVShowContainer;
  final TVShowListContainer searchTVShowContainer;
  final String searchQuerry;

  bool get isSearchMode => searchQuerry.isNotEmpty;
  List<TvShow> get movies =>
      isSearchMode ? searchTVShowContainer.shows : popularTVShowContainer.shows;

  const TVShowListState.initial()
      : popularTVShowContainer = const TVShowListContainer.initial(),
        searchTVShowContainer = const TVShowListContainer.initial(),
        searchQuerry = "";

  TVShowListState({
    required this.popularTVShowContainer,
    required this.searchTVShowContainer,
    required this.searchQuerry,
  });

  @override
  bool operator ==(covariant TVShowListState other) {
    if (identical(this, other)) return true;

    return other.popularTVShowContainer == popularTVShowContainer &&
        other.searchTVShowContainer == searchTVShowContainer &&
        other.searchQuerry == searchQuerry;
  }

  @override
  int get hashCode =>
      popularTVShowContainer.hashCode ^
      searchTVShowContainer.hashCode ^
      searchQuerry.hashCode;

  TVShowListState copyWith({
    TVShowListContainer? popularTVShowContainer,
    TVShowListContainer? searchMovieContainer,
    String? searchQuerry,
  }) {
    return TVShowListState(
      popularTVShowContainer:
          popularTVShowContainer ?? this.popularTVShowContainer,
      searchTVShowContainer:
          searchMovieContainer ?? this.popularTVShowContainer,
      searchQuerry: searchQuerry ?? this.searchQuerry,
    );
  }
}

class TVShowListBloc extends Bloc<TvShowListEvent, TVShowListState> {
  final _showApiClient = ShowApiClient();
  TVShowListBloc(TVShowListState initialState) : super(initialState) {
    on<TvShowListEvent>((event, emit) async {
      if (event is TVShowListEventLoadNextPageEvent) {
        await onTVShowListEventLoadNextPageEvent(event, emit);
      } else if (event is TVShowListEventLoadResetEvent) {
        await onTVShowListEventLoadResetEvent(event, emit);
      } else if (event is TVShowListEventLoadSearchMovieEvent) {
        await onListEventLoadSearchTVShowEvent(event, emit);
      }
    }, transformer: sequential());
  }

  Future<TVShowListContainer?> _loadNextPage(
    TVShowListContainer container,
    Future<PopularTvShowResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final shows = container.shows;
    shows.addAll(result.tvShows);

    final newContainer = container.copyWith(
      shows: shows,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onTVShowListEventLoadNextPageEvent(
    TVShowListEventLoadNextPageEvent event,
    Emitter<TVShowListState> emit,
  ) async {
    if (state.isSearchMode) {
      final container = await _loadNextPage(
        state.searchTVShowContainer,
        (nextPage) async {
          final result = await _showApiClient.searchShow(
            nextPage,
            event.locale,
            state.searchQuerry,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularTVShowContainer: container);
        emit(newState);
      }
    } else {
      final container = await _loadNextPage(
        state.popularTVShowContainer,
        (nextPage) async {
          final result = await _showApiClient.popularTvShow(
            nextPage,
            event.locale,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularTVShowContainer: container);
        emit(newState);
      }
    }
  }

  Future<void> onTVShowListEventLoadResetEvent(
    TVShowListEventLoadResetEvent event,
    Emitter<TVShowListState> emit,
  ) async {
    emit(const TVShowListState.initial());
    add(TVShowListEventLoadNextPageEvent(locale: event.locale));
  }

  Future<void> onListEventLoadSearchTVShowEvent(
    TVShowListEventLoadSearchMovieEvent event,
    Emitter<TVShowListState> emit,
  ) async {
    if (state.searchQuerry == event.querry) return;
    final newState = state.copyWith(
        searchQuerry: event.querry,
        searchMovieContainer: const TVShowListContainer.initial());
    emit(newState);
    add(TVShowListEventLoadNextPageEvent(locale: event.locale));
  }
}
