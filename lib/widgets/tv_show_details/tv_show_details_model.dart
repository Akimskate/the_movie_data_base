// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/Library/localized_model.dart';
import 'package:moviedb/domain/api_client/extension_api_client.dart';
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
}

class TvShowDetailsModel extends ChangeNotifier {
  final authService = AuthService();
  final showService = ShowService();
  final int showId;
  final data = TvShowDetailsData();
  final _localeStorage = LocalizedModelStorage();
  late DateFormat _dateFormat;
  TvShowDetailsModel(this.showId);

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
      final ditails = await showService.loadDetailsShow(
          showId: showId, locale: _localeStorage.localeTag);

      updateData(ditails.details, ditails.isFavoriteShow);
    } on ApiClientException catch (e) {
      _handleApiClienException(e, context);
    }
  }

  void updateData(TvShowDetails? details, bool isFavoriteShow) {
    data.title = details?.name ?? 'Loading...';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
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

    notifyListeners();
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
    // final runtime = details.episodeRunTime?[0] ?? 0;
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
    data.posterShowData = data.posterShowData
        .copyWith(isFavoriteShow: !data.posterShowData.isFavoriteShow);
    notifyListeners();
    try {
      await showService.updateFavoriteShow(
        isFavoriteShow: data.posterShowData.isFavoriteShow,
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
        authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}
