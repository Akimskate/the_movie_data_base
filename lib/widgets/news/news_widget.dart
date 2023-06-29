import 'package:flutter/material.dart';
import 'package:moviedb/widgets/news/news_top_search_bar.dart';
import 'package:moviedb/widgets/news/news_widget_free_to_watch.dart';
import 'package:moviedb/widgets/news/news_widget_leaderboards.dart';
import 'package:moviedb/widgets/news/news_widget_popular.dart';
import 'package:moviedb/widgets/news/news_widget_trailers.dart';
import 'package:moviedb/widgets/news/news_widget_trandings.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        NewsTopSearchBar(),
        NewsWidgetTrandings(),
        NewsWidgetTrailers(),
        NewsWidgetFreeToWatch(),
        NewsWidgetPopular(),
        NewsWidgetLeaderboards(),
      ],
    );
  }
}
