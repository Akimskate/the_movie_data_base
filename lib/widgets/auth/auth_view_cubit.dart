import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/domain/api_client/extension_api_client.dart';
import 'package:moviedb/domain/blocs/auth_bloc.dart';
import 'package:moviedb/domain/blocs/auth_event.dart';
import 'package:moviedb/domain/blocs/auth_state.dart';

abstract class AuthViewCubitState {}

class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {}

class AuthViewCubitErrorState extends AuthViewCubitState {
  final String? errorMessage;

  AuthViewCubitErrorState(this.errorMessage);
}

class AuthViewCubitAuthProgressState extends AuthViewCubitState {}

class AuthViewCubitSuccsessState extends AuthViewCubitState {}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> streamSubscription;

  AuthViewCubit(AuthViewCubitState initialState, this.authBloc)
      : super(initialState) {
    _onState(authBloc.state);
    streamSubscription = authBloc.stream.listen(_onState);
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  void auth({required String login, required String password}) {
    if (!_isValid(login, password)) {
      final state = AuthViewCubitErrorState('Fill your loggin and password');
      emit(state);
      return;
    }

    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  void _onState(AuthState state) {
    if (state is AuthUnautorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthAutirizedState) {
      emit(AuthViewCubitSuccsessState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitErrorState(message));
    } else if (state is AuthInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    } else if (state is AuthCheckStatusInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return 'Unknown error, please tyr later';
    }
    switch (error.type) {
      case ApiClientExceptionType.network:
        return 'Server unawailable';
      case ApiClientExceptionType.auth:
        return 'Wrong login or password! ! !';
      case ApiClientExceptionType.sessionExpired:
      case ApiClientExceptionType.others:
        return 'Somethig wrong, try later';
    }
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}

// class AuthViewModel extends ChangeNotifier {
//   final _authService = AuthService();

//   final loginTextController = TextEditingController(text: 'akimskate');
//   final passwordTextController = TextEditingController(text: '7B7L!WHimcY8K8!');

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   bool _isAuthProgress = false;
//   bool get canStartAuth => !_isAuthProgress;
//   bool get isAuthProgress => _isAuthProgress;

//   bool _isValid(String login, String password) =>
//       login.isNotEmpty && password.isNotEmpty;

//   Future<String?> _login(String login, String password) async {
//     try {
//       await _authService.login(login, password);
//     } on ApiClientException catch (e) {
//       switch (e.type) {
//         case ApiClientExceptionType.network:
//           return 'Server unawailable';
//         case ApiClientExceptionType.auth:
//           return 'Wrong login or password! ! !';
//         case ApiClientExceptionType.sessionExpired:
//         case ApiClientExceptionType.others:
//           return 'Somethig wrong, try later';
//       }
//     } catch (e) {
//       return 'Unknown Error. Please try again later';
//     }
//     return null;
//   }

//   Future<void> auth(BuildContext context) async {
//     final login = loginTextController.text;
//     final password = passwordTextController.text;

//     if (!_isValid(login, password)) {
//       _updateState('Fill your loggin and password', false);
//       return;
//     }

//     _updateState(null, true);

//     _errorMessage = await _login(login, password);
//     if (_errorMessage == null) {
//       MainNavigation.resetNavigation(context);
//     } else {
//       _updateState(_errorMessage, false);
//     }
//   }

//   void _updateState(String? errorMessage, bool isAuthProgress) {
//     if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
//       return;
//     }
//     _errorMessage = errorMessage;
//     _isAuthProgress = isAuthProgress;
//     notifyListeners();
//   }
// }
