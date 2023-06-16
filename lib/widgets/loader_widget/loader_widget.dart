import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/navigation/main_navigation.dart';
import 'package:moviedb/widgets/loader_widget/loader_view_cubit.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: onListenWhen,
      listener: onLoaderViewCubitStateChange,
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  bool onListenWhen(LoaderViewCubitState prev, LoaderViewCubitState current) {
    return current != LoaderViewCubitState.unknown;
  }

  void onLoaderViewCubitStateChange(
    BuildContext context,
    LoaderViewCubitState state,
  ) {
    final nextScreen = state == LoaderViewCubitState.authorized
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
