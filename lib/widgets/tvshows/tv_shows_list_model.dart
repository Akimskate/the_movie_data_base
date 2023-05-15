import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/Library/paginator.dart';
import 'package:moviedb/configuration/configuratioin.dart';
import 'package:moviedb/domain/api_client/show_api_client.dart';
import 'package:moviedb/domain/entity/tv_show.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';
import 'package:moviedb/domain/services/show_service.dart';
import 'package:moviedb/navigation/main_navigation.dart';

class ShowListRowData {
  final String name;
  final int id;
  final String? posterPath;
  final String title;
  final String firstairDate;
  final String overview;

  ShowListRowData(
      {required this.name,
        required this.id,
      required this.posterPath,
      required this.title,
      required this.firstairDate,
      required this.overview});
}

class ShowListViewModel extends ChangeNotifier {
  final _showService = ShowService();

  late final Paginator<TvShow> _popularShowPaginator;
  late final Paginator<TvShow> _searchShowPaginator;

  String? _searchQuery;
  Timer? searchDebounce;
  late String _locale = '';

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }
  
  var _shows = <ShowListRowData>[];

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';
  
  

  List<ShowListRowData> get shows => List.unmodifiable(_shows);
  late DateFormat _dateFormat;


  ShowListViewModel() {
    _popularShowPaginator = Paginator<TvShow>((page) async {
      final result = await _showService.popularTvShow(page, _locale);
      return PaginatorLoadResult(
          data: result.tvShows,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    _searchShowPaginator = Paginator<TvShow>((page) async {
      final result = await _showService.searchMovie(
        page,
        _locale,
        _searchQuery ?? '',
      );
      return PaginatorLoadResult(
          data: result.tvShows,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }
  


  Future<void> setupLocal(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _searchShowPaginator.reset();
    await _popularShowPaginator.reset();
    _shows.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchShowPaginator.loadNextPage();
      _shows = _searchShowPaginator.data.map(_makeRowData).toList();
    } else {
      await _popularShowPaginator.loadNextPage();
      _shows = _popularShowPaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
  }

  ShowListRowData _makeRowData(TvShow shows) {
    final firstairDate = shows.firstairDate;
    final firstairDateTitle =
        firstairDate != null ? _dateFormat.format(firstairDate) : '';

    return ShowListRowData(
      name: shows.name,
      id: shows.id,
      overview: shows.overview,
      posterPath: shows.posterPath,
      firstairDate: firstairDateTitle,
      title: shows.name,
    );
  }


  void onShowTap(BuildContext context, int index) {
    final id = _shows[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.showDetails,
      arguments: id,
    );
  }

  Future<void> searchShow(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _shows.clear();
      if (isSearchMode){
        await _searchShowPaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedTvshowAtIndex(int index) {
    if (index < _shows.length - 1) return;
    _loadNextPage();
  }
}
