// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/domain/entity/local_entities/movie_details_local.dart';
import 'package:moviedb/domain/entity/local_entities/tv_show_details_local.dart';
import 'package:moviedb/domain/services/show_service.dart';

abstract class TVShowDetailsEvent {}

class LoadTVShowDetailsEvent extends TVShowDetailsEvent {
  final String locale;

  LoadTVShowDetailsEvent(this.locale);
}

class ToggleFavoriteEvent extends TVShowDetailsEvent {}

class TVShowDetailsState {
  final bool isLoading;
  final TvShowDetailsLocal? details;
  final bool isFavorite;

  TVShowDetailsState({
    required this.isLoading,
    required this.details,
    required this.isFavorite,
  });

  TVShowDetailsState copyWith({
    bool? isLoading,
    TvShowDetailsLocal? details,
    bool? isFavorite,
  }) {
    return TVShowDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(covariant TVShowDetailsState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        other.details == details &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^ details.hashCode ^ isFavorite.hashCode;
}

class TVShowDetailsBloc extends Bloc<TVShowDetailsEvent, TVShowDetailsState> {
  final ShowService _showService;
  final int showId;

  TVShowDetailsBloc(this.showId, this._showService)
      : super(TVShowDetailsState(
            isLoading: true, details: null, isFavorite: false));

  Stream<TVShowDetailsState> mapEventToState(TVShowDetailsEvent event) async* {
    if (event is LoadTVShowDetailsEvent) {
      yield* _mapLoadTVShowDetailsEventToState(event);
    } else if (event is ToggleFavoriteEvent) {
      yield* _mapToggleFavoriteEventToState(event);
    }
  }

  Stream<TVShowDetailsState> _mapLoadTVShowDetailsEventToState(
      LoadTVShowDetailsEvent event) async* {
    try {
      final details = await _showService.loadDetailsShow(
          showId: showId, locale: event.locale);
      yield state.copyWith(isLoading: false, details: details);
    } catch (e) {
      yield state.copyWith(isLoading: false, details: state.details);
    }
  }

  Stream<TVShowDetailsState> _mapToggleFavoriteEventToState(
      ToggleFavoriteEvent event) async* {
    final isFavorite = !state.isFavorite;
    yield state.copyWith(isFavorite: isFavorite);

    try {
      await _showService.updateFavoriteShow(
          isFavoriteShow: isFavorite, showId: showId);
    } catch (e) {
      rethrow;
    }
  }
}
