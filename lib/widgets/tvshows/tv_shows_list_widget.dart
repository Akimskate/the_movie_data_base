// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/widgets/tvshows/tv_shows_list_model.dart';

class ShowListWidget extends StatefulWidget {
  const ShowListWidget({Key? key}) : super(key: key);

  @override
  State<ShowListWidget> createState() => _ShowListWidgetState();
}

class _ShowListWidgetState extends State<ShowListWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ShowListViewModel>().setupLocal(context);
  }
  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: const [
        _ShowListWidget(),
        _SearchWidget(),
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ShowListViewModel>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: model.searchShow,
        decoration: InputDecoration(
          labelText: 'Search',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _ShowListWidget extends StatelessWidget {
  const _ShowListWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final model = context.watch<ShowListViewModel>();
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(top: 70),
      itemCount: model.shows.length,
      itemExtent: 163,
      itemBuilder: (BuildContext context, int index) {
        model.showedTvshowAtIndex(index);
        
        return _MovieListRowWidget(index: index);
      },
    );
  }
}
class _MovieListRowWidget extends StatelessWidget {
  final int index;
  const _MovieListRowWidget({
    Key? key,
    required this.index,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ShowListViewModel>();
    final shows = model.shows[index];
        final posterPath = shows.posterPath;
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 25,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Row(
                  children: [
                    if (posterPath != null)
                        Image.network(
                            ImageDownloader.imageUrl(posterPath),
                            width: 95,
                          ),
                        
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            shows.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            shows.firstairDate,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            shows.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => model.onShowTap(context, index),
                ),
              )
            ],
          ),
        );
  }
}
