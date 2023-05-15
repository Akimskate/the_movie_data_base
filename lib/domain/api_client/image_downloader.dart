import 'package:moviedb/configuration/configuratioin.dart';

class ImageDownloader {
  static String imageUrl(String path) => Configuration.imageUrl + path;
}