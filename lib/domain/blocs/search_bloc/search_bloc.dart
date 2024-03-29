import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/domain/entity/popular_movie_response.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';
import 'package:moviedb/domain/services/movie_service.dart';
import 'package:moviedb/domain/services/show_service.dart';

abstract class SearchEvent {}

class FetchSearchResultsEvent extends SearchEvent {
  final String locale;
  final String querry;

  FetchSearchResultsEvent({
    required this.locale,
    required this.querry,
  });
}

class SearchResultListEventLoadNextPage extends SearchEvent {
  final String locale;
  SearchResultListEventLoadNextPage({
    required this.locale,
  });
}

class SearchState {
  final PopularMovieResponse movieSearchResultContainer;
  final PopularTvShowResponse showSearchResultContainer;
  final String searchQuerry;

  SearchState({
    required this.movieSearchResultContainer,
    required this.showSearchResultContainer,
    required this.searchQuerry,
  });

  SearchState.initial()
      : movieSearchResultContainer = PopularMovieResponse(
          page: 0,
          totalPages: 1,
          totalResults: 1,
          movies: [],
        ),
        showSearchResultContainer = PopularTvShowResponse(
          page: 0,
          totalPages: 1,
          totalResults: 1,
          tvShows: [],
        ),
        searchQuerry = "";

  @override
  bool operator ==(covariant SearchState other) {
    if (identical(this, other)) return true;

    return other.movieSearchResultContainer == movieSearchResultContainer &&
        other.showSearchResultContainer == showSearchResultContainer &&
        other.searchQuerry == searchQuerry;
  }

  @override
  int get hashCode =>
      movieSearchResultContainer.hashCode ^
      showSearchResultContainer.hashCode ^
      searchQuerry.hashCode;

  SearchState copyWith({
    PopularMovieResponse? movieSearchResultContainer,
    PopularTvShowResponse? showSearchResultContainer,
    String? searchQuerry,
  }) {
    return SearchState(
      movieSearchResultContainer:
          movieSearchResultContainer ?? this.movieSearchResultContainer,
      showSearchResultContainer:
          showSearchResultContainer ?? this.showSearchResultContainer,
      searchQuerry: searchQuerry ?? this.searchQuerry,
    );
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieService _movieService;
  final ShowService _showService;

  SearchBloc(SearchState initialState, this._movieService, this._showService)
      : super(initialState) {
    on<FetchSearchResultsEvent>(_handleSearchMovieEvent);
    on<SearchResultListEventLoadNextPage>(onSearchEventLoadNextPageEvent);
  }

  Future<SearchState> _loadNextPage(
    PopularMovieResponse movieSearchResultContainer,
    PopularTvShowResponse showSearchResultContainer,
    Future<PopularMovieResponse> Function(int) movieLoader,
    Future<PopularTvShowResponse> Function(int) showLoader,
  ) async {
    final nextMoviePage = movieSearchResultContainer.page + 1;
    final nextShowPage = showSearchResultContainer.page + 1;
    final resultMovies = await movieLoader(nextMoviePage);
    final resultShow = await showLoader(nextShowPage);
    final newMovieList = [
      ...movieSearchResultContainer.movies,
      ...resultMovies.movies,
    ];

    final newShowList = [
      ...showSearchResultContainer.tvShows,
      ...resultShow.tvShows,
    ];

    final newMovieSearchResultContainer = movieSearchResultContainer.copyWith(
      movies: newMovieList,
      page: nextMoviePage,
    );

    final newShowSearchResultContainer = showSearchResultContainer.copyWith(
      tvShows: newShowList,
      page: nextShowPage,
    );

    final newSearchResultContainer = state.copyWith(
      movieSearchResultContainer: newMovieSearchResultContainer,
      showSearchResultContainer: newShowSearchResultContainer,
      searchQuerry: state.searchQuerry,
    );

    return newSearchResultContainer;
  }

  Future<void> onSearchEventLoadNextPageEvent(
    SearchResultListEventLoadNextPage event,
    Emitter<SearchState> emit,
  ) async {
    final container = await _loadNextPage(
      state.movieSearchResultContainer,
      state.showSearchResultContainer,
      (nextPage) async {
        final result = await _movieService.searchMovie(
          nextPage,
          event.locale,
          state.searchQuerry,
        );
        return result;
      },
      (nextPage) async {
        final result = await _showService.searchTvShow(
          nextPage,
          event.locale,
          state.searchQuerry,
        );
        return result;
      },
    );
    final newState = state.copyWith(
        movieSearchResultContainer: container.movieSearchResultContainer,
        showSearchResultContainer: container.showSearchResultContainer,
        searchQuerry: state.searchQuerry);
    emit(newState);
  }

  void _handleSearchMovieEvent(
      FetchSearchResultsEvent event, Emitter<SearchState> emit) async {
    final movieSearchResults = await _movieService.searchMovie(
      1,
      event.locale,
      event.querry,
    );

    final showSearchResults = await _showService.searchTvShow(
      1,
      event.locale,
      event.querry,
    );
    emit(state.copyWith(
      movieSearchResultContainer: movieSearchResults,
      showSearchResultContainer: showSearchResults,
      searchQuerry: event.querry,
    ));
  }
}
