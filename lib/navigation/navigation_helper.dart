import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/movie_api_client.dart';
import 'package:moviedb/navigation/main_navigation.dart';

class NavigationHelper {
  static void navigateToMovieDetails(BuildContext context, int movieId) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: movieId,
    );
  }

  static void navigateToShowDetails(BuildContext context, int showId) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.showDetails,
      arguments: showId,
    );
  }

  static void navigateToMovieTrailer(BuildContext context, int movieId) async {
    final moiveDetails = await MovieApiClient().movieDetails(movieId, 'en-EN');
    final youtubeKey = moiveDetails.videos.results[0].key;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieTrailerWidget,
      arguments: youtubeKey,
    );
  }
}
