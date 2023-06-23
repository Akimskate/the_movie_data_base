// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:moviedb/Library/localized_model.dart';
import 'package:moviedb/domain/api_client/extension_api_client.dart';
import 'package:moviedb/domain/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:moviedb/domain/entity/local_entities/movie_details_local.dart';
import 'package:moviedb/domain/entity/movie_details.dart';
import 'package:moviedb/domain/services/auth_service.dart';
import 'package:moviedb/domain/services/movie_service.dart';
import 'package:moviedb/navigation/main_navigation.dart';

class MovieDetailsPosterData {
  final String? backdropPath;
  final bool isFavorite;
  final String? posterPath;
  IconData get favoriteIcon =>
      isFavorite ? Icons.favorite : Icons.favorite_outline;

  MovieDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
  });

  MovieDetailsPosterData copyWith({
    String? backdropPath,
    bool? isFavorite,
    String? posterPath,
  }) {
    return MovieDetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      isFavorite: isFavorite ?? this.isFavorite,
      posterPath: posterPath ?? this.posterPath,
    );
  }
}

class MovieDetailsMovieScoreData {
  final String? trailerKey;
  final double voteAverage;

  MovieDetailsMovieScoreData({
    this.trailerKey,
    required this.voteAverage,
  });
}

class MovieDetailsMoviePeopleData {
  final String name;
  final String job;

  MovieDetailsMoviePeopleData({
    required this.name,
    required this.job,
  });
}

class MovieDetailsMovieActorData {
  final String actor;
  final String character;
  final String? profilePath;
  MovieDetailsMovieActorData({
    required this.actor,
    required this.character,
    this.profilePath,
  });
}

class MovieDetailsMovieNameData {
  String name;
  String year;
  MovieDetailsMovieNameData({
    required this.name,
    required this.year,
  });
}

class MovieDetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  MovieDetailsPosterData posterData = MovieDetailsPosterData();
  MovieDetailsMovieNameData nameData = MovieDetailsMovieNameData(
    name: '',
    year: '',
  );
  MovieDetailsMovieScoreData scoreData = MovieDetailsMovieScoreData(
    voteAverage: 0,
  );
  String summary = '';
  List<List<MovieDetailsMoviePeopleData>> peopleData =
      const <List<MovieDetailsMoviePeopleData>>[];
  List<MovieDetailsMovieActorData> actorData =
      const <MovieDetailsMovieActorData>[];

  static MovieDetailsData fromLocal(MovieDetailsLocal? localData) {
    MovieDetailsData movieDetailsData = MovieDetailsData();
    if (localData == null) {
      return movieDetailsData;
    }
    return movieDetailsData;
  }
}

class MovieDetailsCubitState {
  final MovieDetailsData movieData;
  final String localeTag;

  MovieDetailsCubitState({
    required this.movieData,
    required this.localeTag,
  });

  MovieDetailsCubitState copyWith({
    MovieDetailsData? movieData,
    String? localeTag,
  }) {
    return MovieDetailsCubitState(
      movieData: movieData ?? this.movieData,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}

class MovieDetailsCubit extends Cubit<MovieDetailsCubitState> {
  final int movieId;
  final data = MovieDetailsData();
  final _localeStorage = LocalizedModelStorage();
  late DateFormat _dateFormat;
  final _authService = AuthService();
  final _movieService = MovieService();
  final MovieDetailsBloc movieDetailsBloc;
  late final StreamSubscription<MovieDetailsState> movieDetailsBlocSubscription;

  MovieDetailsCubit({
    required this.movieDetailsBloc,
    required this.movieId,
  }) : super(
          MovieDetailsCubitState(
            movieData: MovieDetailsData(),
            localeTag: "",
          ),
        ) {
    Future.microtask(() {
      _onState(movieDetailsBloc.state);
      movieDetailsBlocSubscription = movieDetailsBloc.stream.listen(_onState);
    });
  }
  void _onState(MovieDetailsState state) {
    final movieData = MovieDetailsData.fromLocal(state.details);
    final newState = this.state.copyWith(movieData: movieData);
    emit(newState);
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    updateData(null, false);
    await loadDetails(context);
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final details = await _movieService.loadDetails(
        movieId: movieId,
        locale: _localeStorage.localeTag,
      );

      updateData(details.details, details.isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    final currentData = data;

    currentData.title = details?.title ?? 'Loading...';
    currentData.isLoading = details == null;
    if (details == null) {
      emit(state.copyWith(movieData: currentData));
      return;
    }
    currentData.overview = details.overview ?? '';
    currentData.posterData = MovieDetailsPosterData(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      isFavorite: isFavorite,
    );
    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    currentData.nameData = MovieDetailsMovieNameData(
      name: details.title,
      year: year,
    );
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    currentData.scoreData = MovieDetailsMovieScoreData(
      trailerKey: trailerKey,
      voteAverage: details.voteAverage * 10,
    );
    currentData.summary = makeSummary(details);
    currentData.peopleData = makePeopleData(details);
    currentData.actorData = details.credits.cast
        .map(
          (e) => MovieDetailsMovieActorData(
            actor: e.name,
            character: e.character,
            profilePath: e.profilePath,
          ),
        )
        .toList();

    emit(state.copyWith(movieData: currentData));
  }

  String makeSummary(MovieDetails details) {
    var texts = <String>[];
    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }

    if (details.productionCountries.isNotEmpty) {
      texts.add('(${details.productionCountries.first.iso})');
    }
    final runtime = details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    if (details.genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genre in details.genres) {
        genresNames.add(genre.name);
      }
      texts.add(genresNames.join(', '));
    }
    return texts.join(', ');
  }

  List<List<MovieDetailsMoviePeopleData>> makePeopleData(MovieDetails details) {
    var crew = details.credits.crew
        .map((e) => MovieDetailsMoviePeopleData(name: e.name, job: e.job))
        .toList();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<MovieDetailsMoviePeopleData>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }
    return crewChunks;
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final currentData = state.movieData;

    currentData.posterData = currentData.posterData.copyWith(
      isFavorite: !currentData.posterData.isFavorite,
    );

    emit(state.copyWith(movieData: currentData));

    try {
      await _movieService.updateFavorite(
        isFavorite: currentData.posterData.isFavorite,
        movieId: movieId,
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(
    ApiClientException exception,
    BuildContext context,
  ) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}
