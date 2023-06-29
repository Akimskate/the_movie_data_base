import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/Theme/app_colors.dart';
import 'package:moviedb/domain/blocs/tab_bloc/tab_cubit.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const drawerHeaderTextStyle = TextStyle(color: Colors.white, fontSize: 20);
    const drawerBodyTextStyle = TextStyle(color: Colors.grey, fontSize: 16);

    final tabCubit = BlocProvider.of<TabSelectedCubit>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 119),
      child: ClipPath(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.drawerBackGround,
                  ),
                ),
              ),
              ListView(
                padding: const EdgeInsets.only(top: 0),
                itemExtent: 40,
                children: [
                  ListTile(
                    onTap: () {
                      tabCubit.movieTabSelected();
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "Movies",
                      style: drawerHeaderTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      tabCubit.tvShowTabSelected();
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "TV Shows",
                      style: drawerHeaderTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      tabCubit.newsTabSelected();
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "People",
                      style: drawerHeaderTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "Contribution Bible",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "Discussions",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "Leaderboard",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "Contribution Bible",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "API",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "Support",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "Contribution Bible",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "About",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: const Text(
                      "Logout",
                      style: drawerBodyTextStyle,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
