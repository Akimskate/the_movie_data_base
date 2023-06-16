// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/Theme/app_button_style.dart';
import 'package:moviedb/navigation/main_navigation.dart';
import 'package:moviedb/widgets/auth/auth_view_cubit.dart';
import 'package:provider/provider.dart';

class _AuthDataStorage {
  String login = 'akimskate';
  String password = '7B7L!WHimcY8K8!';
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewCubit, AuthViewCubitState>(
      listener: _onAuthViewCubitStateChange,
      child: Provider(
        create: (_) => _AuthDataStorage(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Login to tour account'),
          ),
          body: ListView(
            children: [
              _HeaderWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void _onAuthViewCubitStateChange(
    BuildContext context,
    AuthViewCubitState state,
  ) {
    if (state is AuthViewCubitSuccsessState) {
      MainNavigation.resetNavigation(context);
    }
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          _FormWidget(),
          SizedBox(height: 50),
          Text(
            'In order to use the editing and rating capabilities of TMDB, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple.',
            style: textStyle,
          ),
          TextButton(
            onPressed: () {},
            style: AppButtonStyle.linkButton,
            child: Text('Register'),
          ),
          SizedBox(height: 25),
          Text(
            'If you signed up but did not get your verification email.',
            style: textStyle,
          ),
          TextButton(
            onPressed: () {},
            style: AppButtonStyle.linkButton,
            child: Text('Verification email'),
          ),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authDataStorage = context.read<_AuthDataStorage>();
    final textStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );
    final textFieldDecorator = const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isCollapsed: true,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        Text(
          'Login',
          style: textStyle,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          decoration: textFieldDecorator,
          onChanged: (text) => authDataStorage.login = 'akimskate',
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Password',
          style: textStyle,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          decoration: textFieldDecorator,
          onChanged: (text) => authDataStorage.password = '7B7L!WHimcY8K8!',
          obscureText: true,
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            _AuthButtonWidget(),
            SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: () {},
              style: AppButtonStyle.linkButton,
              child: Text('Reset password'),
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AuthViewCubit>();
    final authDataStorage = _AuthDataStorage();
    final color = const Color(0xFF01B4E4);
    final canStartAuth = cubit.state is AuthViewCubitFormFillInProgressState ||
        cubit.state is AuthViewCubitErrorState;
    final onPressed = canStartAuth
        ? () => cubit.auth(
            login: authDataStorage.login, password: authDataStorage.password)
        : null;
    final child = cubit.state is AuthViewCubitAuthProgressState
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : const Text('Login');
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
        ),
      ),
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewCubit c) {
      final state = c.state;
      return state is AuthViewCubitErrorState ? state.errorMessage : null;
    });
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: TextStyle(
          fontSize: 17,
          color: Colors.red,
        ),
      ),
    );
  }
}
