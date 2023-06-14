import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:moviedb/domain/blocs/auth_bloc.dart';
import 'package:moviedb/domain/blocs/auth_event.dart';
import 'package:moviedb/domain/blocs/auth_state.dart';

enum LoaderViewCubitState { unknown, authorized, notAuthorized }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> streamSubscription;
  LoaderViewCubit(
    LoaderViewCubitState initialState,
    this.authBloc,
  ) : super(initialState) {
    authBloc.add(AuthCheckStatusEvent());
    onState(authBloc.state);
    streamSubscription = authBloc.stream.listen(onState);
  }

  void onState(AuthState state) {
    if (state is AuthAutirizedState) {
      emit(LoaderViewCubitState.authorized);
    } else if (state is AuthUnautorizedState) {
      emit(LoaderViewCubitState.notAuthorized);
    }
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
