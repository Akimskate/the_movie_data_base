// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/api_client/account_api_client.dart';
import 'package:moviedb/domain/api_client/extension_api_client.dart';
import 'package:moviedb/domain/api_client/show_api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/domain/entity/tv_show_details.dart';
import 'package:moviedb/domain/services/auth_service.dart';
import 'package:moviedb/navigation/main_navigation.dart';

class TvShowDetailsModel extends ChangeNotifier {
  final authService = AuthService();
  final _showApiClient = ShowApiClient();
  final _apiClientAccount = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final int showId;
  TvShowDetails? _showDetails;
  bool _isFavoriteShow = false;
  String _locale = '';
  late DateFormat _dateFormat;

  TvShowDetails? get showDetails => _showDetails;
  bool get isFavoriteShow => _isFavoriteShow;

  TvShowDetailsModel(this.showId);

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await loadDetails(context);
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      _showDetails = await _showApiClient.showDetails(
        showId,
        _locale,
      );
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavoriteShow =
            await _showApiClient.isFavoriteShow(showId, sessionId);
      }
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClienException(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    if (accountId == null || sessionId == null) return;

    _isFavoriteShow = !_isFavoriteShow;
    notifyListeners();
    try {
      await _apiClientAccount.markAsFavoriteShow(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.tv,
        mediaId: showId,
        isFavoriteShow: _isFavoriteShow,
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
