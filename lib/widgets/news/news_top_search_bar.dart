import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/Theme/app_colors.dart';
import 'package:moviedb/domain/blocs/search_bloc/search_bloc.dart';
import 'package:moviedb/domain/services/movie_service.dart';
import 'package:moviedb/domain/services/show_service.dart';
import 'package:moviedb/navigation/main_navigation.dart';
import 'package:moviedb/resources/resources.dart';

class NewsTopSearchBar extends StatelessWidget {
  const NewsTopSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) =>
          SearchBloc(SearchState.initial(), MovieService(), ShowService()),
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
              opacity: 0.9,
              image: AssetImage(AppImages.topNewsSearchBarBackground),
              fit: BoxFit.cover),
          color: Colors.black.withOpacity(1),
        ),
        height: 250,
        child: const Stack(children: [
          Padding(
            padding: EdgeInsets.only(left: 18, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Millions of movies, TV shows and people to discover. Explore Now.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                _SearchField(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final cubit = context.read<SearchBloc>();

    return Container(
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextField(
              controller: searchController,
              maxLength: 30,
              cursorColor: Colors.grey,
              cursorWidth: 1,
              decoration: const InputDecoration(
                hintText: 'Search...',
                counterText: '',
                hintStyle: TextStyle(fontSize: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(25),
                    right: Radius.circular(25),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.firstMainGradientColor,
                      AppColors.secondMainGradientColor,
                    ],
                  )),
              child: TextButton(
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () => {
                        cubit.add(FetchSearchResultsEvent(
                          locale: 'en-EN',
                          querry: searchController.text,
                        )),
                        Navigator.of(context).pushNamed(
                          MainNavigationRouteNames.showSearchResults,
                          arguments: searchController.text,
                        )
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
