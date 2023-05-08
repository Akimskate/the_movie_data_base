import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/api_client.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiCliet = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Fill your loggin and password';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();

    String? sessionId;
    int? accountId;
    try {
      sessionId = await _apiCliet.auth(
        username: login,
        password: password,
      );
    accountId = await _apiCliet.getAccountInfo(sessionId);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          _errorMessage = 'Server unawailable';
          break;
        case ApiClientExceptionType.auth:
          _errorMessage = 'Wrong login or password! ! !';
          break;
        case ApiClientExceptionType.others:
          _errorMessage = 'Somethig wrong, try later';
          break;
        case ApiClientExceptionType.sessionExpired:
          break;
      }
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
    if (sessionId == null || accountId == null) {
      _errorMessage = 'Unknown Error. Please try again later';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
    Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen);
  }
}