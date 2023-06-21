// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
// import 'package:moviedb/Library/localized_model.dart';
// import 'package:moviedb/Library/paginator.dart';
// import 'package:moviedb/domain/entity/movie.dart';
// import 'package:moviedb/domain/services/movie_service.dart';
// import 'package:moviedb/navigation/main_navigation.dart';

// class MovieListRowData {
//   final int id;
//   final String? posterPath;
//   final String title;
//   final String releaseDate;
//   final String overview;

//   MovieListRowData(
//       {required this.id,
//       required this.posterPath,
//       required this.title,
//       required this.releaseDate,
//       required this.overview});
// }

// class MovieListViewModel extends ChangeNotifier {
//   final _movieService = MovieService();

//   late final Paginator<Movie> _popularMoviePaginator;
//   late final Paginator<Movie> _searchMoviePaginator;
//   var _movies = <MovieListRowData>[];
//   String? _searchQuery;
//   Timer? searchDebounce;
//   final _localeStorage = LocalizedModelStorage();

//   bool get isSearchMode {
//     final searchQuery = _searchQuery;
//     return searchQuery != null && searchQuery.isNotEmpty;
//   }

//   List<MovieListRowData> get movies => List.unmodifiable(_movies);
//   late DateFormat _dateFormat;

//   MovieListViewModel() {
//     _popularMoviePaginator = Paginator<Movie>((page) async {
//       final result = await _movieService.popularMovie(page, _localeStorage.localeTag);
//       return PaginatorLoadResult(
//           data: result.movies,
//           currentPage: result.page,
//           totalPage: result.totalPages);
//     });
//     _searchMoviePaginator = Paginator<Movie>((page) async {
//       final result = await _movieService.searchMovie(
//         page,
//         _localeStorage.localeTag,
//         _searchQuery ?? '',
//       );
//       return PaginatorLoadResult(
//           data: result.movies,
//           currentPage: result.page,
//           totalPage: result.totalPages);
//     });
//   }

//   Future<void> setupLocal(Locale locale) async {
//     if (!_localeStorage.updateLocale(locale)) return;
//     _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
//     await _resetList();
//   }

//   Future<void> _resetList() async {
//     await _searchMoviePaginator.reset();
//     await _popularMoviePaginator.reset();
//     _movies.clear();
//     await _loadNextPage();
//   }

//   Future<void> _loadNextPage() async {
//     if (isSearchMode) {
//       await _searchMoviePaginator.loadNextPage();
//       _movies = _searchMoviePaginator.data.map(_makeRowData).toList();
//     } else {
//       await _popularMoviePaginator.loadNextPage();
//       _movies = _popularMoviePaginator.data.map(_makeRowData).toList();
//     }
//     notifyListeners();
//   }

//   MovieListRowData _makeRowData(Movie movie) {
//     final releaseDate = movie.releaseDate;
//     final releaseDataTitle =
//         releaseDate != null ? _dateFormat.format(releaseDate) : '';

//     return MovieListRowData(
//       id: movie.id,
//       overview: movie.overview,
//       posterPath: movie.posterPath,
//       releaseDate: releaseDataTitle,
//       title: movie.title,
//     );
//   }

//   void onMoveiTap(BuildContext context, int index) {
//     final id = _movies[index].id;
//     Navigator.of(context).pushNamed(
//       MainNavigationRouteNames.movieDetails,
//       arguments: id,
//     );
//   }

//   Future<void> searchMovie(String text) async {
//     searchDebounce?.cancel();
//     searchDebounce = Timer(const Duration(milliseconds: 00), () async {
//       final searchQuery = text.isNotEmpty ? text : null;
//       if (_searchQuery == searchQuery) return;
//       _searchQuery = searchQuery;
//       _movies.clear();
//       if (isSearchMode){
//         await _searchMoviePaginator.reset();
//       }
//       _loadNextPage();
//     });
//   }

//   void showedMovieAtIndex(int index) {
//     if (index < _movies.length - 1) return;
//     _loadNextPage();
//   }
// }
