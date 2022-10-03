import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/domain/api_client/api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/domain/entity/tv_show_details.dart';

class TvShowDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final int showId;
  TvShowDetails? _showDetails;
  bool _isFavoriteShow = false;
  String _locale = '';
  late DateFormat _dateFormat;
  Future<void>? Function()? onSessionExpired;

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
    await loadDetails();
  }

  Future<void> loadDetails() async {
    try {
      _showDetails = await _apiClient.showDetails(showId, _locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    if (sessionId != null) {
      _isFavoriteShow = await _apiClient.isFavoriteShow(showId, sessionId);
    }
    notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClienException(e);
    }
    
  }

  Future<void> toggleFavorite() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    if (accountId == null || sessionId == null) return;

    _isFavoriteShow = !_isFavoriteShow;
    notifyListeners();
    try {
      await _apiClient.markAsFavoriteShow(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.TV,
        mediaId: showId,
        isFavoriteShow: _isFavoriteShow,
      );
    } on ApiClientException catch (e) {
      _handleApiClienException(e);
      }
    }
  

  void _handleApiClienException(ApiClientException exception) {
    switch (exception.type){
        case ApiClientExceptionType.sessionExpired:
        onSessionExpired?.call();
        break;
        default:
        print(exception);
      }
  }
}