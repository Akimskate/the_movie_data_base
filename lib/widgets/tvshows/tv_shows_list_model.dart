import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/api_client/api_client_movie_and_show.dart';
import 'package:moviedb/domain/entity/tv_show.dart';
import 'package:moviedb/domain/entity/popular_tv_show_response.dart';
import 'package:moviedb/navigation/main_navigation.dart';

class TvShowListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _shows = <TvShow>[];
  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgress = false;
  String? _searchQuery;
  Timer? searchDebounce;

  List<TvShow> get shows => List.unmodifiable(_shows);
  late DateFormat _dateFormat;
  late String _locale = '';

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocal(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _shows.clear();
    await _loadNextPage();
  }

  Future<PopularTvShowResponse> _loadShows(int nextPage, String locale) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.popularTvShow(nextPage, _locale);
    } else {
      return await _apiClient.searchShow(nextPage, locale, query);
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try {
      final showResponse = await _loadShows(nextPage, _locale);
      _shows.addAll(showResponse.tvShows);
      _currentPage = showResponse.page;
      _totalPage = showResponse.totalPages;
      _isLoadingInProgress = false;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  void onShowTap(BuildContext context, int index) {
    final id = _shows[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.showDetails,
      arguments: id,
    );
  }

  Future<void> searchShow(String text) async {
    searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      await _resetList();
    });
  }

  void showedTvshowAtIndex(int index) {
    if (index < _shows.length - 1) return;
    _loadNextPage();
  }
}
