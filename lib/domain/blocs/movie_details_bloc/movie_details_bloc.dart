// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/domain/entity/local_entities/movie_details_local.dart';
import 'package:moviedb/domain/services/movie_service.dart';

abstract class MovieDetailsEvent {}

class LoadMovieDetailsEvent extends MovieDetailsEvent {
  final String locale;

  LoadMovieDetailsEvent(this.locale);
}

class ToggleFavoriteEvent extends MovieDetailsEvent {}

class MovieDetailsState {
  final bool isLoading;
  final MovieDetailsLocal? details;
  final bool isFavorite;

  // MovieDetailsLocal? get detail => details;

  MovieDetailsState({
    required this.isLoading,
    required this.details,
    required this.isFavorite,
  });

  MovieDetailsState copyWith({
    bool? isLoading,
    MovieDetailsLocal? details,
    bool? isFavorite,
  }) {
    return MovieDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(covariant MovieDetailsState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        other.details == details &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^ details.hashCode ^ isFavorite.hashCode;
}

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieService _movieService;
  final int movieId;

  MovieDetailsBloc(this.movieId, this._movieService)
      : super(MovieDetailsState(
            isLoading: true, details: null, isFavorite: false));

  Stream<MovieDetailsState> mapEventToState(MovieDetailsEvent event) async* {
    if (event is LoadMovieDetailsEvent) {
      yield* _mapLoadMovieDetailsEventToState(event);
    } else if (event is ToggleFavoriteEvent) {
      yield* _mapToggleFavoriteEventToState(event);
    }
  }

  Stream<MovieDetailsState> _mapLoadMovieDetailsEventToState(
      LoadMovieDetailsEvent event) async* {
    try {
      final details = await _movieService.loadDetails(
          movieId: movieId, locale: event.locale);
      yield state.copyWith(isLoading: false, details: details);
    } catch (e) {
      // Обработка ошибки
      yield state.copyWith(isLoading: false, details: state.details);
    }
  }

  Stream<MovieDetailsState> _mapToggleFavoriteEventToState(
      ToggleFavoriteEvent event) async* {
    // Обновление состояния избранного фильма
    final isFavorite = !state.isFavorite;
    yield state.copyWith(isFavorite: isFavorite);

    try {
      await _movieService.updateFavorite(
          isFavorite: isFavorite, movieId: movieId);
    } catch (e) {
      // Обработка ошибки
    }
  }
}
