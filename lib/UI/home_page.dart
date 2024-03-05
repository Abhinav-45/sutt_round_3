import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutt_round3/Data%20Storage%20and%20API%20Calls/riverpod.dart';
import 'package:sutt_round3/Models/fetch_movies.dart';
import 'package:sutt_round3/Models/movie_details.dart';
import 'package:sutt_round3/Models/now_playing_movies.dart';
import 'package:sutt_round3/Provider/provider.dart';
import '../Logic/like.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowPlayingMovies = ref.watch(nowPlayingProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
            child: Text('Movie Search',
                style: TextStyle(
                    fontFamily: 'Anta', fontSize: screenHeight * 0.028))),
        backgroundColor: Colors.cyan,
      ),
      body: nowPlayingMovies.when(
        data: (data) {
          final movies = data.movieResults;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchBox(),
              const SizedBox(height: 10),
              Expanded(
                child: _buildMovieGrid(context, movies),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

Widget _buildMovieGrid(BuildContext context, List<MovieResult> movies) {
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

class MovieCard extends ConsumerWidget {
  final MovieResult movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize = screenWidth * 0.04;

    final imgurl = ref.watch(imagesProvider(movie.imdbId));

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
        selectedMovieId.setSelectedImdbId(movie.imdbId);
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
                  '${movie.title} (${movie.year})',
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

class SearchBox extends ConsumerWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) {
          ref.watch(searchQuery.notifier).update((state) => value);
        },
        decoration: InputDecoration(
          icon: const Icon(Icons.search),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          hintText: "Search Movies...",
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          border: InputBorder.none,
        ),
        onTap: () {
          context.go('/search');
        },
      ),
    );
  }
}
