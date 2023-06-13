import 'package:moviedb/domain/entity/tv_show_details.dart';

class TvShowDetailsLocal {
  final TvShowDetails details;
  final bool isFavorite;

  TvShowDetailsLocal({
    required this.details,
    required this.isFavorite,
  });
}
