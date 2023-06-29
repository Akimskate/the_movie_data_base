import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/domain/blocs/tab_bloc/tab_cubit.dart';
import 'package:moviedb/domain/factoryes/screen_factory.dart';
import 'package:moviedb/domain/services/auth_service.dart';
import 'package:moviedb/resources/resources.dart';
import 'package:moviedb/resources/tab_index_converter.dart';
import 'package:moviedb/widgets/auth/main_screen/drawer_widget.dart';

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  int _selectedTabIndex(TabSelectedState state) {
    return TabIndexConverter.convertToTabIndex(state.selectedTab);
  }

  @override
  Widget build(BuildContext context) {
    final tabSelecteBloc = TabSelectedCubit();
    final _authService = AuthService();
    final _screenFactory = ScreenFactory();

    return BlocProvider<TabSelectedCubit>(
      create: (context) => tabSelecteBloc,
      child: Scaffold(
        appBar: AppBar(
          title: IconButton(
            icon: const Image(
              image: AssetImage(AppImages.imdbLogo),
            ),
            onPressed: () {},
            iconSize: 60,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _authService.logout,
              icon: const Icon(Icons.logout),
            ),
          ],
          toolbarHeight: 71,
        ),
        body: BlocBuilder<TabSelectedCubit, TabSelectedState>(
          builder: (context, state) {
            return IndexedStack(
              index: _selectedTabIndex(state),
              children: [
                _screenFactory.makeNewsList(),
                _screenFactory.makeMovieList(),
                _screenFactory.makeTVShowList(),
              ],
            );
          },
        ),
        drawerScrimColor: Colors.transparent,
        drawer: const DrawerWidget(),
        bottomNavigationBar: BlocBuilder<TabSelectedCubit, TabSelectedState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: _selectedTabIndex(state),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie_filter),
                  label: 'Movies',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tv),
                  label: 'Series',
                ),
              ],
              onTap: (index) {
                final tabCubit = BlocProvider.of<TabSelectedCubit>(context);
                if (index == 0) {
                  tabCubit.newsTabSelected();
                } else if (index == 1) {
                  tabCubit.movieTabSelected();
                } else if (index == 2) {
                  tabCubit.tvShowTabSelected();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
