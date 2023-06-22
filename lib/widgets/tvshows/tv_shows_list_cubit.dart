import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/blocs/tv_show_list_bloc/tv_show_list_bloc.dart';
import 'package:moviedb/domain/entity/tv_show.dart';

class TVShowListRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String firstairDate;
  final String overview;

  TVShowListRowData(
      {required this.id,
      required this.posterPath,
      required this.title,
      required this.firstairDate,
      required this.overview});
}

class TVShowListCubitState {
  final List<TVShowListRowData> shows;
  final String localeTag;

  TVShowListCubitState({
    required this.shows,
    required this.localeTag,
  });

  @override
  bool operator ==(covariant TVShowListCubitState other) {
    if (identical(this, other)) return true;

    return listEquals(other.shows, shows) && other.localeTag == localeTag;
  }

  @override
  int get hashCode => shows.hashCode ^ localeTag.hashCode;

  TVShowListCubitState copyWith({
    List<TVShowListRowData>? shows,
    String? localeTag,
    String? searchQuerry,
  }) {
    return TVShowListCubitState(
      shows: shows ?? this.shows,
      localeTag: localeTag ?? this.localeTag,
    );
  }
}

class TVShowListCubit extends Cubit<TVShowListCubitState> {
  final TVShowListBloc tvShowListBloc;
  late DateFormat _dateFormat;
  Timer? searchDebounce;
  late final StreamSubscription<TVShowListState> tvShowListBlocSubscription;
  TVShowListCubit({
    required this.tvShowListBloc,
  }) : super(
          TVShowListCubitState(
            shows: const <TVShowListRowData>[],
            localeTag: "",
          ),
        ) {
    Future.microtask(() {
      _onState(tvShowListBloc.state);
      tvShowListBlocSubscription = tvShowListBloc.stream.listen(_onState);
    });
  }
  void _onState(TVShowListState state) {
    final shows = state.shows.map(_makeRowData).toList();
    final newState = this.state.copyWith(shows: shows);
    emit(newState);
  }

  void setupLocal(String localeTag) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    tvShowListBloc.add(TVShowListEventLoadResetEvent());
    tvShowListBloc.add(TVShowListEventLoadNextPageEvent(locale: localeTag));
  }

  void showedTVShowAtIndex(int index) {
    if (index < state.shows.length - 1) return;
    tvShowListBloc.add(
      TVShowListEventLoadNextPageEvent(locale: state.localeTag),
    );
  }

  void searchTVShow(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      tvShowListBloc.add(
        TVShowListEventLoadSearchTVShowEvent(
          text,
        ),
      );
      tvShowListBloc.add(
        TVShowListEventLoadNextPageEvent(locale: state.localeTag),
      );
    });
  }

  @override
  Future<void> close() {
    tvShowListBlocSubscription.cancel();
    return super.close();
  }

  TVShowListRowData _makeRowData(TvShow shows) {
    final releaseDate = shows.firstairDate;
    final releaseDataTitle =
        releaseDate != null ? _dateFormat.format(releaseDate) : '';

    return TVShowListRowData(
      id: shows.id,
      overview: shows.overview,
      posterPath: shows.posterPath,
      firstairDate: releaseDataTitle,
      title: shows.name,
    );
  }
}
