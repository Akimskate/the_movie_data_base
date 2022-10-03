import 'package:flutter/material.dart';
import 'package:moviedb/Library/Widgets/inherited/provider.dart';
import 'package:moviedb/widgets/au/auth_model.dart';
import 'package:moviedb/widgets/au/auth_widget.dart';
import 'package:moviedb/widgets/au/main_screen/main_screen_model.dart';
import 'package:moviedb/widgets/au/main_screen/main_screen_widget.dart'; 
import 'package:moviedb/widgets/movie_details_widget/movie_details_model.dart';
import 'package:moviedb/widgets/movie_details_widget/movie_details_widget.dart';
import 'package:moviedb/widgets/movie_trailers/movie_trailer_widget.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_model.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_widget.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const mainScreen = '/main_screen';
  static const movieDetails = '/movie_details';
  static const movieTrailerWidget = '/movie_details/trailer';
  static const showDetails = '/show_details';
  static const loaderWidget = '/';
}

class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRouteNames.mainScreen
      : MainNavigationRouteNames.auth;
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.auth: (context) => NotifierProvider(
          create: () => AuthModel(),
          child: const AuthWidget(),
        ),
    MainNavigationRouteNames.mainScreen: (context) => NotifierProvider(
          create: () => MainScreenModel(),
          child: const MainScreenWidget(),
        ),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
            create: () => MovieDetailsModel(movieId),
            child: const MovieDetailsWidget(),
          ),
        );
      case MainNavigationRouteNames.movieTrailerWidget:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (context) => MovieTrailerWidget(youtubeKey: youtubeKey),
        );
      case MainNavigationRouteNames.showDetails:
        final arguments = settings.arguments;
        final showId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
            create: () => TvShowDetailsModel(showId),
            child: const TvShowDetailsWidget(),
          ),
        );
      default:
        const widget = Text('Navigation Error!!!!!!!!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
