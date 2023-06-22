abstract class TvShowListEvent {}

class TVShowListEventLoadNextPageEvent extends TvShowListEvent {
  final String locale;

  TVShowListEventLoadNextPageEvent({
    required this.locale,
  });
}

class TVShowListEventLoadResetEvent extends TvShowListEvent {}

class TVShowListEventLoadSearchTVShowEvent extends TvShowListEvent {
  final String querry;

  TVShowListEventLoadSearchTVShowEvent(
    this.querry,
  );
}
