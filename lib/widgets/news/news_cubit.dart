// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:moviedb/domain/blocs/news_bloc/news_bloc.dart';
import 'package:moviedb/domain/entity/trending.dart';

class TrendingListRowData {
  final int id;
  final String? posterPath;
  final String? title;
  final String? name;
  final String? releaseDate;
  final String? firstAirDate;
  final String mediaType;
  final double voteAverage;

  TrendingListRowData({
    required this.id,
    this.posterPath,
    required this.title,
    required this.name,
    required this.releaseDate,
    required this.firstAirDate,
    required this.mediaType,
    required this.voteAverage,
  });
}

class TrendingListCubitState {
  final List<TrendingListRowData> trending;
  final String localeTag;
  final bool isLoading;
  final String selectedTiwmeWindow;
  TrendingListCubitState({
    required this.trending,
    required this.localeTag,
    required this.isLoading,
    required this.selectedTiwmeWindow,
  });

  @override
  bool operator ==(covariant TrendingListCubitState other) {
    if (identical(this, other)) return true;

    return listEquals(other.trending, trending) &&
        other.localeTag == localeTag &&
        other.isLoading == isLoading &&
        other.selectedTiwmeWindow == selectedTiwmeWindow;
  }

  @override
  int get hashCode {
    return trending.hashCode ^
        localeTag.hashCode ^
        isLoading.hashCode ^
        selectedTiwmeWindow.hashCode;
  }

  TrendingListCubitState copyWith({
    List<TrendingListRowData>? trending,
    String? localeTag,
    bool? isLoading,
    String? selectedTiwmeWindow,
  }) {
    return TrendingListCubitState(
      trending: trending ?? this.trending,
      localeTag: localeTag ?? this.localeTag,
      isLoading: isLoading ?? this.isLoading,
      selectedTiwmeWindow: selectedTiwmeWindow ?? this.selectedTiwmeWindow,
    );
  }
}

class TrendingListCubit extends Cubit<TrendingListCubitState> {
  final NewsBloc newsBloc;
  late DateFormat _dateFormat;

  late final StreamSubscription<NewsState> newsListBlocSubscription;
  TrendingListCubit({required this.newsBloc})
      : super(TrendingListCubitState(
          trending: const <TrendingListRowData>[],
          localeTag: '',
          isLoading: true,
          selectedTiwmeWindow: '',
        )) {
    Future.microtask(() {
      _onState(newsBloc.state);
      newsListBlocSubscription = newsBloc.stream.listen(_onState);
    });
  }
  void _onState(NewsState state) {
    final trending = state.trendinList.results.map(_makeRowData).toList();
    final newState =
        this.state.copyWith(trending: trending, isLoading: state.isLoading);

    emit(newState);
  }

  @override
  Future<void> close() {
    newsListBlocSubscription.cancel();
    return super.close();
  }

  void setupLocal(String localeTag, String timeWindow) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    newsBloc.add(FetchInitialNewsEvent(timeWindow));
    newsBloc.add(ToggleTrendingMoviesEvent(timeWindow));
  }

  TrendingListRowData _makeRowData(Trending trending) {
    final releaseDate = trending.releaseDate;
    final firstAirDate = trending.firstAirDate;
    final airDateTitle = trending.mediaType == 'tv' && firstAirDate != null
        ? _dateFormat.format(firstAirDate)
        : null;
    final releaseDateTitle =
        trending.mediaType == 'movie' && releaseDate != null
            ? _dateFormat.format(releaseDate)
            : null;

    return TrendingListRowData(
      id: trending.id,
      posterPath: trending.posterPath,
      releaseDate: releaseDateTitle,
      firstAirDate: airDateTitle,
      mediaType: trending.mediaType,
      voteAverage: trending.voteAverage,
      title: trending.title,
      name: trending.name,
    );
  }
}
