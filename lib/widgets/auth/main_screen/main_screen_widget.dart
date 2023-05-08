// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:moviedb/Library/Widgets/inherited/provider.dart';
import 'package:moviedb/domain/data_providers/session_data_provider.dart';
import 'package:moviedb/widgets/movie_list/movie_list_model.dart';
import 'package:moviedb/widgets/movie_list/movie_list_widget.dart';
import 'package:moviedb/widgets/news/news_widget.dart';
import 'package:moviedb/widgets/tvshows/tv_shows_list_model.dart';
import 'package:moviedb/widgets/tvshows/tv_shows_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();
  final showListModel = TvShowListModel();

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movieListModel.setupLocal(context);
    showListModel.setupLocal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
        actions: [
          IconButton(
            onPressed: () => SessionDataProvider().setSessionId(null),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          const NewsWidget(),
          NotifierProvider(
            create: () => movieListModel,
            isManagingModel: false,
            child: MovieListWidget(),
          ),
          NotifierProvider(
            create: () => showListModel,
            isManagingModel: false,
            child: ShowListWidget(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Новости',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter),
            label: 'Фильмы',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Сериалы',
          ),
        ],
        onTap: onSelectTab,
      ),
    );
  }
}
