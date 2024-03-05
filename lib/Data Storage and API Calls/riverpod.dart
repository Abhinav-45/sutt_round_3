import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sutt_round3/Models/movie_details.dart';
import 'package:sutt_round3/Models/movie_image.dart';
import 'package:sutt_round3/Models/now_playing_movies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/fetch_movies.dart';

final imagesProvider =
    FutureProvider.family<MovieImages, String>((ref, imdbId) async {
  var url = Uri.parse('https://movies-tv-shows-database.p.rapidapi.com/');
  var headers = {
    'Type': 'get-movies-images-by-imdb',
    'X-RapidAPI-Key': '2f2f32c952mshc6d45da0909dc36p1de4f3jsn1cb6d11bb2b2',
    'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
  };
  var params = {'movieid': imdbId};

  var response =
      await http.get(url.replace(queryParameters: params), headers: headers);

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    return MovieImages.fromJson(responseData);
  } else {
    throw Exception('Failed to load images');
  }
});

final movieDetailsProvider =
    FutureProvider.family<MovieDetails, String>((ref, imdbId) async {
  var url = Uri.https(
      'movies-tv-shows-database.p.rapidapi.com', '/', {'movieid': imdbId});
  print('hoe');

  var headers = {
    'Type': 'get-movie-details',
    'X-RapidAPI-Key': '2f2f32c952mshc6d45da0909dc36p1de4f3jsn1cb6d11bb2b2',
    'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com'
  };

  try {
    var response = await http.get(url, headers: headers);
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print('Response data: $responseData');
      return MovieDetails.fromJson(responseData);
    } else {
      throw Exception(
          'Failed to load movie details. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Failed to load movie details: $error');
  }
});

final nowPlayingProvider = FutureProvider<NowPlaying>((ref) async {
  var headers = {
    'Type': 'get-nowplaying-movies',
    'X-RapidAPI-Key': '2f2f32c952mshc6d45da0909dc36p1de4f3jsn1cb6d11bb2b2',
    'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
  };

  var uri =
      Uri.https('movies-tv-shows-database.p.rapidapi.com', '/', {'page': '1'});

  var response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    return NowPlaying.fromJson(responseData);
  } else {
    throw Exception('Failed to fetch now playing movies');
  }
});

final fetchMoviesProvider =
    FutureProvider.family<MoviesByTitle, String>((ref, inputText) async {
  var headers = {
    'Type': 'get-movies-by-title',
    'X-RapidAPI-Key': '2f2f32c952mshc6d45da0909dc36p1de4f3jsn1cb6d11bb2b2',
    'X-RapidAPI-Host': 'movies-tv-shows-database.p.rapidapi.com',
  };

  var uri = Uri.https(
      'movies-tv-shows-database.p.rapidapi.com', '/', {'title': inputText});

  var response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    return MoviesByTitle.fromJson(responseData);
  } else {
    throw Exception('Failed to fetch movies by title');
  }
});

class SelectedMovieId extends ChangeNotifier {
  String _selectedImdbId = '';

  String get selectedImdbId => _selectedImdbId;

  void setSelectedImdbId(String imdbId) {
    _selectedImdbId = imdbId;
    notifyListeners();
  }
}

final selectedMovieIdProvider = ChangeNotifierProvider<SelectedMovieId>((ref) {
  return SelectedMovieId();
});

final selectedImdbIdProvider = Provider<String>((ref) {
  final selectedMovieId = ref.watch(selectedMovieIdProvider);
  return selectedMovieId.selectedImdbId;
});

final searchQuery = StateProvider((ref) => "");
