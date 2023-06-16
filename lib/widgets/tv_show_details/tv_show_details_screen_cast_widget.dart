import 'package:flutter/material.dart';
import 'package:moviedb/domain/api_client/image_downloader.dart';
import 'package:moviedb/widgets/tv_show_details/tv_show_details_model.dart';
import 'package:provider/provider.dart';

class TvShowDetailsMainScreenCastWidget extends StatelessWidget {
  const TvShowDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Series Casst',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(
            height: 270,
            child: Scrollbar(
              child: _ActorWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              onPressed: () {},
              child: const Text('Full Cast & Crew'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorWidget extends StatelessWidget {
  const _ActorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data =
        context.select((TvShowDetailsModel model) => model.data.actorData);

    if (data.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      itemCount: data.length,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _ActorItemListWidget(actorIndex: index);
      },
    );
  }
}

class _ActorItemListWidget extends StatelessWidget {
  final int actorIndex;
  const _ActorItemListWidget({
    Key? key,
    required this.actorIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<TvShowDetailsModel>();
    final actor = model.data.actorData[actorIndex];
    final profilePath = actor.profilePath;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
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
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              profilePath != null
                  ? Image.network(ImageDownloader.imageUrl(profilePath))
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actor.actor,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      actor.character,
                      maxLines: 2,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
