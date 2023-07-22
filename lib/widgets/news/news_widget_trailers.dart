import 'package:flutter/material.dart';
import 'package:moviedb/resources/resources.dart';

class NewsWidgetTrailers extends StatefulWidget {
  const NewsWidgetTrailers({Key? key}) : super(key: key);

  @override
  _NewsWidgetTrailersState createState() => _NewsWidgetTrailersState();
}

class _NewsWidgetTrailersState extends State<NewsWidgetTrailers> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          colorFilter:
              ColorFilter.mode(Colors.blueGrey.shade700, BlendMode.modulate),
          image: const AssetImage(AppImages.upcomingTrailersBackGround),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Trailers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemExtent: constraints.maxWidth * 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: const Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage(AppImages.img),
                                      ),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 20,
                                                spreadRadius: -20),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 80,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 15,
                                right: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.more_horiz),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Elite',
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
                            child: Text(
                              'Elite Season 4 | Trailter | Netflix',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
