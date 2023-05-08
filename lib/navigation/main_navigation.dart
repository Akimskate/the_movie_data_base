import 'package:flutter/material.dart';
import 'package:moviedb/Library/Widgets/inherited/provider.dart';
import 'package:moviedb/domain/factoryes/screen_factory.dart';
import 'package:moviedb/widgets/movie_details_widget/movie_details_model.dart';
import 'package:moviedb/widgets/movie_details_widget/movie_details_widget.dart';
import 'package:moviedb/widgets/movie_trailers/movie_trailer_widget.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_model.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_widget.dart';

abstract class MainNavigationRouteNames {
  static const loaderWidget = '/';
  static const auth = 'auth';
  static const mainScreen = '/main_screen';
  static const movieDetails = '/main_screen/movie_details';
  static const movieTrailerWidget = '/main_screen/movie_details/trailer';
  static const showDetails = '/main_screen/show_details';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.loaderWidget: (_) => _screenFactory.makeLoader(),
    MainNavigationRouteNames.auth: (_) => _screenFactory.makeAuth(),
    MainNavigationRouteNames.mainScreen: (_) => _screenFactory.makeMainScreen(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeMovieDetails(movieId),
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
