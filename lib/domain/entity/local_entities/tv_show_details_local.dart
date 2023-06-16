import 'package:moviedb/domain/entity/tv_show_details.dart';

class TvShowDetailsLocal {
  final TvShowDetails details;
  final bool isFavoriteShow;

  TvShowDetailsLocal({
    required this.details,
    required this.isFavoriteShow,
  });
}
