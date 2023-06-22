import 'package:moviedb/domain/entity/tv_show.dart';

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
  List<TvShow> get shows =>
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
    TVShowListContainer? searchTVShowContainer,
    String? searchQuerry,
  }) {
    return TVShowListState(
      popularTVShowContainer:
          popularTVShowContainer ?? this.popularTVShowContainer,
      searchTVShowContainer:
          searchTVShowContainer ?? this.searchTVShowContainer,
      searchQuerry: searchQuerry ?? this.searchQuerry,
    );
  }
}
