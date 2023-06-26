// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/Library/localized_model.dart';
import 'package:moviedb/domain/api_client/extension_api_client.dart';
import 'package:moviedb/domain/blocs/tv_show_details_bloc/tv_show_details_bloc.dart';

import 'package:moviedb/domain/entity/local_entities/tv_show_details_local.dart';
import 'package:moviedb/domain/entity/tv_show_details.dart';
import 'package:moviedb/domain/services/auth_service.dart';
import 'package:moviedb/domain/services/show_service.dart';
import 'package:moviedb/navigation/main_navigation.dart';

class TvShowDetailsPosterData {
  final String? backdropPath;
  final bool isFavoriteShow;
  final String? posterPath;
  IconData get favoriteIcon =>
      isFavoriteShow ? Icons.favorite : Icons.favorite_outline;

  TvShowDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavoriteShow = false,
  });

  TvShowDetailsPosterData copyWith({
    String? backdropPath,
    bool? isFavoriteShow,
    String? posterPath,
  }) {
    return TvShowDetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      isFavoriteShow: isFavoriteShow ?? this.isFavoriteShow,
      posterPath: posterPath ?? this.posterPath,
    );
  }
}

class TvShowDetailsScoreData {
  final String? trailerKey;
  final double voteAverage;

  TvShowDetailsScoreData({
    this.trailerKey,
    required this.voteAverage,
  });
}

class TvShowDetailsPeopleData {
  final String name;
  final String job;

  TvShowDetailsPeopleData({
    required this.name,
    required this.job,
  });
}

class TvShowDetailsActorData {
  final String actor;
  final String character;
  final String? profilePath;
  TvShowDetailsActorData({
    required this.actor,
    required this.character,
    this.profilePath,
  });
}

class TvShowDetailsNameData {
  String name;
  String year;
  TvShowDetailsNameData({
    required this.name,
    required this.year,
  });
}

class TvShowDetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  TvShowDetailsPosterData posterShowData = TvShowDetailsPosterData();
  TvShowDetailsNameData nameData = TvShowDetailsNameData(
    name: '',
    year: '',
  );
  TvShowDetailsScoreData scoreData = TvShowDetailsScoreData(
    voteAverage: 0,
  );
  String summary = '';
  List<List<TvShowDetailsPeopleData>> peopleData =
      const <List<TvShowDetailsPeopleData>>[];
  List<TvShowDetailsActorData> actorData = const <TvShowDetailsActorData>[];

  static TvShowDetailsData fromLocal(TvShowDetailsLocal? localData) {
    TvShowDetailsData showDetailsData = TvShowDetailsData();
    if (localData == null) {
      return showDetailsData;
    }
    return showDetailsData;
  }
}

class TVShowDetailsCubitState {
  final TvShowDetailsData showData;
  final String localeTag;

  TVShowDetailsCubitState({
    required this.showData,
    required this.localeTag,
  });

  TVShowDetailsCubitState copyWith({
    TvShowDetailsData? showData,
    String? localeTag,
  }) {
    return TVShowDetailsCubitState(
      showData: showData ?? this.showData,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}

class TVShowDetailsCubit extends Cubit<TVShowDetailsCubitState> {
  final int showId;
  final TVShowDetailsBloc showDetailsBloc;
  final data = TvShowDetailsData();
  final _localeStorage = LocalizedModelStorage();
  final _authService = AuthService();
  final _showService = ShowService();
  late DateFormat _dateFormat;
  late final StreamSubscription<TVShowDetailsState> showDetailsBlocSubscription;

  TVShowDetailsCubit({
    required this.showDetailsBloc,
    required this.showId,
  }) : super(
          TVShowDetailsCubitState(
            showData: TvShowDetailsData(),
            localeTag: "",
          ),
        ) {
    Future.microtask(() {
      _onState(showDetailsBloc.state);
      showDetailsBlocSubscription = showDetailsBloc.stream.listen(_onState);
    });
  }
  void _onState(TVShowDetailsState state) {
    final showData = TvShowDetailsData.fromLocal(state.details);
    final newState = this.state.copyWith(showData: showData);
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
      final details = await _showService.loadDetailsShow(
          showId: showId, locale: _localeStorage.localeTag);

      updateData(details.details, details.isFavoriteShow);
    } on ApiClientException catch (e) {
      _handleApiClienException(e, context);
    }
  }

  void updateData(TvShowDetails? details, bool isFavoriteShow) {
    final currentData = data;

    data.title = details?.name ?? 'Loading...';
    data.isLoading = details == null;
    if (details == null) {
      emit(state.copyWith(showData: currentData));
      return;
    }
    data.overview = details.overview;
    data.posterShowData = TvShowDetailsPosterData(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      isFavoriteShow: isFavoriteShow,
    );
    var year = details.firstAirDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.nameData = TvShowDetailsNameData(
      name: details.name,
      year: year,
    );
    final videos = details.videos?.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    data.scoreData = TvShowDetailsScoreData(
      trailerKey: trailerKey,
      voteAverage: details.voteAverage * 10,
    );
    data.summary = makeSummary(details);
    data.peopleData = makePeopleData(details);
    data.actorData = details.credits.cast
        .map(
          (e) => TvShowDetailsActorData(
            actor: e.name,
            character: e.character,
            profilePath: e.profilePath,
          ),
        )
        .toList();
    emit(state.copyWith(showData: currentData));
  }

  String makeSummary(TvShowDetails details) {
    var texts = <String>[];
    final releaseDate = details.firstAirDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }

    if (details.productionCountries.isNotEmpty) {
      texts.add('(${details.productionCountries.first.iso31661})');
    }
    int runtime = 0;
    if (details.episodeRunTime != null && details.episodeRunTime!.isNotEmpty) {
      runtime = details.episodeRunTime![0];
    }
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    if (details.genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in details.genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }
    return texts.join(', ');
  }

  List<List<TvShowDetailsPeopleData>> makePeopleData(TvShowDetails details) {
    var crew = details.credits.crew
        .map((e) => TvShowDetailsPeopleData(name: e.name, job: e.job))
        .toList();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<TvShowDetailsPeopleData>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks.add(
        crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2),
      );
    }
    return crewChunks;
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final currentData = state.showData;

    data.posterShowData = currentData.posterShowData
        .copyWith(isFavoriteShow: !currentData.posterShowData.isFavoriteShow);
    emit(state.copyWith(showData: currentData));
    try {
      await _showService.updateFavoriteShow(
        isFavoriteShow: currentData.posterShowData.isFavoriteShow,
        showId: showId,
      );
    } on ApiClientException catch (e) {
      _handleApiClienException(e, context);
    }
  }

  void _handleApiClienException(
    ApiClientException exception,
    BuildContext context,
  ) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        if (kDebugMode) {
          print(exception);
        }
    }
  }
}
