import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:moviedb/domain/blocs/auth_bloc/auth_bloc.dart';
import 'package:moviedb/domain/blocs/auth_bloc/auth_event.dart';
import 'package:moviedb/domain/blocs/auth_bloc/auth_state.dart';

enum LoaderViewCubitState { unknown, authorized, notAuthorized }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;
  LoaderViewCubit(
    LoaderViewCubitState initialState,
    this.authBloc,
  ) : super(initialState) {
    Future.microtask(
      () {
        _onState(authBloc.state);
        authBlocSubscription = authBloc.stream.listen(_onState);
        authBloc.add(AuthCheckStatusEvent());
      },
    );
  }

  void _onState(AuthState state) {
    if (state is AuthAutirizedState) {
      emit(LoaderViewCubitState.authorized);
    } else if (state is AuthUnautorizedState) {
      emit(LoaderViewCubitState.notAuthorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
