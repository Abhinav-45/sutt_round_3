import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutt_round3/Data%20Storage%20and%20API%20Calls/riverpod.dart';
import 'package:sutt_round3/Models/fetch_movies.dart';

import '../Logic/like.dart';
import '../Models/now_playing_movies.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchtext = ref.watch(searchQuery);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(fontSize: screenHeight * 0.028),
        ),
        backgroundColor: Colors.cyan,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            autofocus: true,
            onChanged: (value) {
              if (searchtext != value) {
                Future.delayed(Duration(milliseconds: 500), () {
                  ref.read(searchQuery.notifier).update((state) => value);
                });
              }
            },
          ),
          Expanded(
            child: _buildSearchResults(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, WidgetRef ref) {
    final searchtext = ref.watch(searchQuery);
    final searchresults = ref.watch(fetchMoviesProvider(searchtext));

    return searchresults.when(
      data: (data) {
        final movie = data.movieResults;
        return _buildSearchGrid(context, movie!);
      },
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: $error',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSearchGrid(BuildContext context, List<MovieResults> movies) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 9 / 16,
        crossAxisCount: 2,
        crossAxisSpacing: screenWidth * 0.01,
        mainAxisSpacing: screenHeight * 0.01,
      ),
      scrollDirection: Axis.vertical,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }
}

class MovieCard extends ConsumerWidget {
  final MovieResults movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize = screenWidth * 0.04;

    final imgurl = ref.watch(imagesProvider(movie.imdbId!));

    final TextStyle customTextStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Anta',
      fontSize: fontSize,
    );

    return GestureDetector(
      onTap: () {
        print(movie.imdbId);
        final selectedMovieId = ref.read(selectedMovieIdProvider);
        selectedMovieId.setSelectedImdbId(movie.imdbId!);
        context.go('/details');
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: imgurl.when(
                          data: (data) {
                            return Image.network(
                              data.poster != null
                                  ? data.poster!
                                  : 'https://i.ibb.co/yNXHsw3/nfjfj.jpg',
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://i.ibb.co/yNXHsw3/nfjfj.jpg',
                                  gaplessPlayback: true,
                                );
                              },
                              gaplessPlayback: true,
                            );
                          },
                          error: (error, stackTrace) =>
                              Center(child: Text('Error: $error')),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.01,
                        right: screenWidth * 0.01,
                        child: like(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Text(
                  '${movie.title} (${movie.year.toString()})',
                  textAlign: TextAlign.center,
                  style: customTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
