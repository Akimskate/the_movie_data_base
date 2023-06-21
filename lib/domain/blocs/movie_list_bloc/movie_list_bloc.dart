// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/movie_api_client.dart';
import 'package:moviedb/domain/blocs/movie_list_bloc/movie_list_state.dart';
import 'package:moviedb/domain/blocs/movie_list_bloc/movie_list_event.dart';
import 'package:moviedb/domain/entity/movie.dart';
import 'package:moviedb/domain/entity/popular_movie_response.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final _movieApiClient = MovieApiClient();

  MovieListBloc(MovieListState initialState) : super(initialState) {
    on<MovieListEvent>((event, emit) async {
      if (event is MovieListEventLoadNextPage) {
        await onMovieListEventLoadNextPageEvent(event, emit);
      } else if (event is MovieListEventLoadReset) {
        await onMovieListEventLoadResetEvent(event, emit);
      } else if (event is MovieListEventLoadSearchMovie) {
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
    final movies = List<Movie>.from(container.movies)..addAll(result.movies);

    final newContainer = container.copyWith(
      movies: movies,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onMovieListEventLoadNextPageEvent(
    MovieListEventLoadNextPage event,
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
        final newState = state.copyWith(searchMovieContainer: container);
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
    MovieListEventLoadReset event,
    Emitter<MovieListState> emit,
  ) async {
    emit(const MovieListState.initial());
  }

  Future<void> onListEventLoadSearchMovieEvent(
    MovieListEventLoadSearchMovie event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.searchQuerry == event.querry) return;
    final newState = state.copyWith(
        searchQuerry: event.querry,
        searchMovieContainer: const MovieListContainer.initial());
    emit(newState);
  }
}
