import 'package:flutter/material.dart';
import 'package:moviedb/Library/Widgets/inherited/provider.dart' as OldProvider;
import 'package:moviedb/widgets/auth/auth_model.dart';
import 'package:moviedb/widgets/auth/auth_widget.dart';
import 'package:moviedb/widgets/auth/main_screen/main_screen_model.dart';
import 'package:moviedb/widgets/auth/main_screen/main_screen_widget.dart';
import 'package:moviedb/widgets/loader_widget/loader_view_model.dart';
import 'package:moviedb/widgets/loader_widget/loader_widget.dart';
import 'package:moviedb/widgets/movie_details_widget/movie_details_model.dart';
import 'package:moviedb/widgets/movie_details_widget/movie_details_widget.dart';
import 'package:moviedb/widgets/movie_trailers/movie_trailer_widget.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_model.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_widget.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
          child: const AuthWidget(),
        );
  }

  Widget makeMainScreen() {
    return OldProvider.NotifierProvider(
          create: () => MainScreenModel(),
          child: const MainScreenWidget(),
        );
  }

  Widget makeMovieDetails(int movieId) {
    return OldProvider.NotifierProvider(
            create: () => MovieDetailsModel(movieId),
            child: const MovieDetailsWidget(),
          );
  }

  Widget makeShowDetails(int showId) {
    return OldProvider.NotifierProvider(
            create: () => TvShowDetailsModel(showId),
            child: const TvShowDetailsWidget(),
          );
  }

  Widget makeYOUTubeTrailer(String youtubeKey){
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }
}