import 'dart:convert';


MoviesByTitle moviesByTitleFromJson(String str) =>
    MoviesByTitle.fromJson(json.decode(str));

class MoviesByTitle {
  final List<MovieResults>? movieResults;
  final int? searchResults;
  final String status;
  final String statusMessage;

  MoviesByTitle({
    required this.movieResults,
    required this.searchResults,
    required this.status,
    required this.statusMessage,
  });

  factory MoviesByTitle.fromJson(Map<String, dynamic> json) => MoviesByTitle(
        movieResults: List<MovieResults>.from(
            json["movie_results"].map((x) => MovieResults.fromJson(x))),
        searchResults: json["search_results"],
        status: json["status"],
        statusMessage: json["status_message"],
      );
}

class MovieResults {
  final String? title;
  final int? year;
  final String? imdbId;
  final int? searchResults;

  MovieResults({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.searchResults,
  });

  factory MovieResults.fromJson(Map<String, dynamic> json) => MovieResults(
        title: json["title"],
        year: json["year"],
        imdbId: json["imdb_id"],
        searchResults: json["search_results"],
      );
}
