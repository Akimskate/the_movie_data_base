import 'package:moviedb/domain/blocs/movie_list_bloc/movie_list_event.dart';
import 'package:moviedb/domain/entity/movie.dart';

class MovieListState {
  final MovieListContainer popularMovieContainer;
  final MovieListContainer searchMovieContainer;
  final String searchQuerry;

  bool get isSearchMode => searchQuerry.isNotEmpty;
  List<Movie> get movies =>
      isSearchMode ? searchMovieContainer.movies : popularMovieContainer.movies;

  const MovieListState.initial()
      : popularMovieContainer = const MovieListContainer.initial(),
        searchMovieContainer = const MovieListContainer.initial(),
        searchQuerry = "";

  MovieListState({
    required this.popularMovieContainer,
    required this.searchMovieContainer,
    required this.searchQuerry,
  });

  @override
  bool operator ==(covariant MovieListState other) {
    if (identical(this, other)) return true;

    return other.popularMovieContainer == popularMovieContainer &&
        other.searchMovieContainer == searchMovieContainer &&
        other.searchQuerry == searchQuerry;
  }

  @override
  int get hashCode =>
      popularMovieContainer.hashCode ^
      searchMovieContainer.hashCode ^
      searchQuerry.hashCode;

  MovieListState copyWith({
    MovieListContainer? popularMovieContainer,
    MovieListContainer? searchMovieContainer,
    String? searchQuerry,
  }) {
    return MovieListState(
      popularMovieContainer:
          popularMovieContainer ?? this.popularMovieContainer,
      searchMovieContainer: searchMovieContainer ?? this.searchMovieContainer,
      searchQuerry: searchQuerry ?? this.searchQuerry,
    );
  }
}
