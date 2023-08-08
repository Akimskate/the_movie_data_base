import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/domain/blocs/auth_bloc/auth_bloc.dart';
import 'package:moviedb/domain/blocs/auth_bloc/auth_state.dart';
import 'package:moviedb/domain/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:moviedb/domain/blocs/movie_list_bloc/movie_list_bloc.dart';
import 'package:moviedb/domain/blocs/movie_list_bloc/movie_list_state.dart';
import 'package:moviedb/domain/blocs/news_bloc/news_bloc.dart';
import 'package:moviedb/domain/blocs/search_bloc/search_bloc.dart';
import 'package:moviedb/domain/blocs/tv_show_details_bloc/tv_show_details_bloc.dart';
import 'package:moviedb/domain/blocs/tv_show_list_bloc/tv_show_list_bloc.dart';
import 'package:moviedb/domain/blocs/tv_show_list_bloc/tv_show_list_state.dart';
import 'package:moviedb/domain/services/movie_service.dart';
import 'package:moviedb/domain/services/news_service.dart';
import 'package:moviedb/domain/services/show_service.dart';
import 'package:moviedb/widgets/auth/auth_view_cubit.dart';
import 'package:moviedb/widgets/auth/auth_widget.dart';
import 'package:moviedb/widgets/auth/main_screen/main_screen_widget.dart';
import 'package:moviedb/widgets/loader_widget/loader_view_cubit.dart';
import 'package:moviedb/widgets/loader_widget/loader_widget.dart';
import 'package:moviedb/widgets/movie_details_widget/movie_details_cubit.dart';
import 'package:moviedb/widgets/movie_details_widget/movie_details_widget.dart';
import 'package:moviedb/widgets/movie_list/movie_list_cubit.dart';
import 'package:moviedb/widgets/movie_list/movie_list_widget.dart';
import 'package:moviedb/widgets/movie_trailers/movie_trailer_widget.dart';
import 'package:moviedb/widgets/news/news_cubit.dart';
import 'package:moviedb/widgets/news/news_widget.dart';
import 'package:moviedb/widgets/search_results/search_result_cubit.dart';
import 'package:moviedb/widgets/search_results/search_results.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_cubit.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_widget.dart';
import 'package:moviedb/widgets/tvshows/tv_shows_list_cubit.dart';
import 'package:moviedb/widgets/tvshows/tv_shows_list_widget.dart';

class ScreenFactory {
  AuthBloc? _authBloc;

  Widget makeLoader() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    return BlocProvider<LoaderViewCubit>(
      create: (context) => LoaderViewCubit(
        LoaderViewCubitState.unknown,
        authBloc,
      ),
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget makeAuth() {
    final authBloc = _authBloc ??
        AuthBloc(
          AuthCheckStatusInProgressState(),
        );
    return BlocProvider<AuthViewCubit>(
      create: (_) => AuthViewCubit(
        AuthViewCubitFormFillInProgressState(),
        authBloc,
      ),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return MainScreenWidget();
  }

  Widget makeSearchResults(String searchQuery) {
    final searchBloc = SearchBloc(
      SearchState.initial(),
      MovieService(),
      ShowService(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(
          create: (_) => searchBloc,
        ),
        BlocProvider<SearchResultListCubit>(
          create: (_) => SearchResultListCubit(searchResultBloc: searchBloc),
        )
      ],
      child: SearchResult(searchQuery: searchQuery),
    );
  }

  Widget makeMovieList() {
    return BlocProvider<MovieListCubit>(
      create: (_) => MovieListCubit(
        movieListBloc: MovieListBloc(
          const MovieListState.initial(),
        ),
      ),
      child: const MovieListWidget(),
    );
  }

  Widget makeMovieDetails(int movieId) {
    final movieDetailsBloc = MovieDetailsBloc(movieId, MovieService());
    return BlocProvider<MovieDetailsCubit>(
      create: (_) => MovieDetailsCubit(
        movieId: movieId,
        movieDetailsBloc: movieDetailsBloc,
      ),
      child: const MovieDetailsWidget(),
    );
  }

  Widget makeShowDetails(int showId) {
    final showDetailsBloc = TVShowDetailsBloc(showId, ShowService());
    return BlocProvider<TVShowDetailsCubit>(
      create: (_) => TVShowDetailsCubit(
        showId: showId,
        showDetailsBloc: showDetailsBloc,
      ),
      child: const TvShowDetailsWidget(),
    );
  }

  Widget makeYOUTubeTrailer(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  Widget makeNewsList() {
    final newsBloc = NewsBloc(
      NewsState.initial(),
      NewsService(),
    );

    final trendingListCubit = TrendingListCubit(newsBloc: newsBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>.value(value: newsBloc),
        BlocProvider<TrendingListCubit>.value(value: trendingListCubit),
      ],
      child: const NewsWidget(),
    );
  }

  Widget makeTVShowList() {
    return BlocProvider<TVShowListCubit>(
      create: (_) => TVShowListCubit(
        tvShowListBloc: TVShowListBloc(
          const TVShowListState.initial(),
        ),
      ),
      child: const ShowListWidget(),
    );
  }
}
