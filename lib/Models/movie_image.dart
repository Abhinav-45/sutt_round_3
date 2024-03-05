import 'dart:convert';

MovieImages movieImageFromJson(String str) =>
    MovieImages.fromJson(json.decode(str));

class MovieImages {
  final String? title;
  final String? imdb;
  final String? poster;
  final String? fanart;

  MovieImages({
    required this.title,
    required this.imdb,
    required this.poster,
    required this.fanart,
  });

  factory MovieImages.fromJson(Map<String, dynamic> json) => MovieImages(
        title: json["title"],
        imdb: json["IMDB"],
        poster: json["poster"],
        fanart: json["fanart"],
      );
}
