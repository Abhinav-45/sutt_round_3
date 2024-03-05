import 'dart:convert';

NowPlaying nowPlayingFromJson(String str) =>
    NowPlaying.fromJson(json.decode(str));

String nowPlayingToJson(NowPlaying data) => json.encode(data.toJson());

class NowPlaying {
  List<MovieResult> movieResults;
  int results;
  String totalResults;
  String status;
  String statusMessage;

  NowPlaying({
    required this.movieResults,
    required this.results,
    required this.totalResults,
    required this.status,
    required this.statusMessage,
  });

  factory NowPlaying.fromJson(Map<String, dynamic> json) => NowPlaying(
        movieResults: List<MovieResult>.from(
            json["movie_results"].map((x) => MovieResult.fromJson(x))),
        results: json["results"],
        totalResults: json["Total_results"],
        status: json["status"],
        statusMessage: json["status_message"],
      );

  Map<String, dynamic> toJson() => {
        "movie_results":
            List<dynamic>.from(movieResults.map((x) => x.toJson())),
        "results": results,
        "Total_results": totalResults,
        "status": status,
        "status_message": statusMessage,
      };
}

class MovieResult {
  String title;
  String year;
  String imdbId;

  MovieResult({
    required this.title,
    required this.year,
    required this.imdbId,
  });

  factory MovieResult.fromJson(Map<String, dynamic> json) => MovieResult(
        title: json["title"],
        year: json["year"],
        imdbId: json["imdb_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "year": year,
        "imdb_id": imdbId,
      };
}
