// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/movie_api_client.dart';
import 'package:moviedb/domain/entity/movie.dart';
import 'package:moviedb/domain/entity/popular_movie_response.dart';

abstract class MovieListEvent {}

class MovieListEventLoadNextPageEvent extends MovieListEvent {
  final String locale;

  MovieListEventLoadNextPageEvent({
    required this.locale,
  });
}

class MovieListEventLoadResetEvent extends MovieListEvent {
  final String locale;

  MovieListEventLoadResetEvent({
    required this.locale,
  });
}

class MovieListEventLoadSearchMovieEvent extends MovieListEvent {
  final String querry;
  final String locale;

  MovieListEventLoadSearchMovieEvent(
    this.querry,
    this.locale,
  );
}

class MovieListContainer {
  final List<Movie> movies;
  final int currentPage;
  final int totalPage;

  bool get isComplete => currentPage >= totalPage;

  const MovieListContainer.initial()
      : movies = const <Movie>[],
        currentPage = 0,
        totalPage = 1;

  MovieListContainer({
    required this.movies,
    required this.currentPage,
    required this.totalPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListContainer &&
          runtimeType == other.runtimeType &&
          movies == other.movies &&
          currentPage == other.currentPage &&
          totalPage == other.totalPage;

  @override
  int get hashCode =>
      movies.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;

  MovieListContainer copyWith({
    List<Movie>? movies,
    int? currentPage,
    int? totalPage,
  }) {
    return MovieListContainer(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }
}

class MovieListState {
  final MovieListContainer popularMovieContainer;
  final MovieListContainer searchMovieContainer;
  final String searchQuerry;

  bool get isSearchMode => searchQuerry.isNotEmpty;

  const MovieListState.initial()
      : popularMovieContainer = const MovieListContainer.initial(),
        searchMovieContainer = const MovieListContainer.initial(),
        searchQuerry = "";

  MovieListState({
    required this.popularMovieContainer,
    required this.searchMovieContainer,
    required this.searchQuerry,
  });

  @override
  bool operator ==(covariant MovieListState other) {
    if (identical(this, other)) return true;

    return other.popularMovieContainer == popularMovieContainer &&
        other.searchMovieContainer == searchMovieContainer &&
        other.searchQuerry == searchQuerry;
  }

  @override
  int get hashCode =>
      popularMovieContainer.hashCode ^
      searchMovieContainer.hashCode ^
      searchQuerry.hashCode;

  MovieListState copyWith({
    MovieListContainer? popularMovieContainer,
    MovieListContainer? searchMovieContainer,
    String? searchQuerry,
  }) {
    return MovieListState(
      popularMovieContainer:
          popularMovieContainer ?? this.popularMovieContainer,
      searchMovieContainer: searchMovieContainer ?? this.searchMovieContainer,
      searchQuerry: searchQuerry ?? this.searchQuerry,
    );
  }
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final _movieApiClient = MovieApiClient();
  MovieListBloc(MovieListState initialState) : super(initialState) {
    on<MovieListEvent>((event, emit) async {
      if (event is MovieListEventLoadNextPageEvent) {
        await onMovieListEventLoadNextPageEvent(event, emit);
      } else if (event is MovieListEventLoadResetEvent) {
        await onMovieListEventLoadResetEvent(event, emit);
      } else if (event is MovieListEventLoadSearchMovieEvent) {
        await onListEventLoadSearchMovieEvent(event, emit);
      }
    }, transformer: sequential());
  }

  Future<MovieListContainer?> _loadNextPage(
    MovieListContainer container,
    Future<PopularMovieResponse> Function(int) loader,
  ) async {
    if (container.isComplete) return null;
    final nextPage = container.currentPage + 1;
    final result = await loader(nextPage);
    final movies = container.movies;
    movies.addAll(result.movies);

    final newContainer = container.copyWith(
      movies: movies,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onMovieListEventLoadNextPageEvent(
    MovieListEventLoadNextPageEvent event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.isSearchMode) {
      final container = await _loadNextPage(
        state.searchMovieContainer,
        (nextPage) async {
          final result = await _movieApiClient.searchMovie(
            nextPage,
            event.locale,
            state.searchQuerry,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularMovieContainer: container);
        emit(newState);
      }
    } else {
      final container = await _loadNextPage(
        state.popularMovieContainer,
        (nextPage) async {
          final result = await _movieApiClient.popularMovie(
            nextPage,
            event.locale,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (container != null) {
        final newState = state.copyWith(popularMovieContainer: container);
        emit(newState);
      }
    }
  }

  Future<void> onMovieListEventLoadResetEvent(
    MovieListEventLoadResetEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(const MovieListState.initial());
    add(MovieListEventLoadNextPageEvent(locale: event.locale));
  }

  Future<void> onListEventLoadSearchMovieEvent(
    MovieListEventLoadSearchMovieEvent event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.searchQuerry == event.querry) return;
    final newState = state.copyWith(
        searchQuerry: event.querry,
        searchMovieContainer: const MovieListContainer.initial());
    emit(newState);
    add(MovieListEventLoadNextPageEvent(locale: event.locale));
  }
}
