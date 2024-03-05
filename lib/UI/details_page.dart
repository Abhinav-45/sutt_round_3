import 'package:flutter/material.dart';
import 'package:sutt_round3/Logic/launch_yt_video.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sutt_round3/Logic/star_rating.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Data Storage and API Calls/riverpod.dart';
import '../Provider/provider.dart';

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? imdbId = ref.watch(selectedImdbIdProvider);
    if (imdbId == null) {
      return Center(child: Text('IMDb ID not available.'));
    }
    final mvdetails = ref.watch(movieDetailsProvider(imdbId));
    final imgurls = ref.watch(imagesProvider(imdbId));
    print(imgurls);

    Uri fanarturl = Uri.parse('https://i.ibb.co/BtpGzBg/Designer-01-01-1.jpg');
    Uri posterurl = Uri.parse('https://i.ibb.co/yNXHsw3/nfjfj.jpg');

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final TextStyle bold = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Anta',
    );

    double fontSize = screenWidth * 0.04;

    final TextStyle customTextStyle = bold.copyWith(fontSize: fontSize);

    if (mvdetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Details',
          style: TextStyle(
            fontFamily: 'Anta',
          ),
        ),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.go('/home');
          },
        ),
        backgroundColor: Colors.cyanAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: mvdetails.when(
          data: (data) {
            return Column(
              children: [
                if (imgurls != null)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.03,
                        horizontal: screenWidth * 0.07),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: false,
                        pageSnapping: true,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.2,
                      ),
                      items: [
                        imgurls.when(
                          data: (data) => Image.network(
                            data.poster != null
                                ? data.poster!
                                : posterurl.toString(),
                            gaplessPlayback: true,
                          ),
                          error: (error, stackTrace) =>
                              Center(child: Text('Error: $error')),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        imgurls.when(
                          data: (d) => Image.network(
                            d.fanart != null ? d.fanart! : fanarturl.toString(),
                            gaplessPlayback: true,
                          ),
                          error: (error, stackTrace) =>
                              Center(child: Text('Error: $error')),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  '${data.title!}  (${data.year!})',
                  style: customTextStyle,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  data.tagline != null
                      ? data.tagline!
                      : "Tagline not Available",
                  style: customTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: screenHeight * 0.02,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.03),
                  child: ExpansionTile(
                    title: Text(
                      'Description',
                      style: customTextStyle.copyWith(
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                    children: <Widget>[
                      Text(
                        data.description != null
                            ? data.description!
                            : "Description not Available",
                        style: customTextStyle.copyWith(
                            fontSize: screenHeight * 0.018),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                data.rated != null
                    ? Center(
                        child: StarRating(
                            imdbRating: double.parse(data.imdbRating!)),
                      )
                    : Text(
                        "Rating: Not Available",
                      ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  data.rated != null
                      ? "Age Rating: ${data.rated!}"
                      : "Age Rating not Available",
                  style: customTextStyle.copyWith(
                    fontSize: screenHeight * 0.022,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  child: Text(
                    'Watch Trailer on Youtube',
                    style: customTextStyle.copyWith(
                      fontSize: screenHeight * 0.024,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    launchYouTubeVideo('${data.youtubeTrailerKey!}');
                  },
                ),
              ],
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        )),
      ),
    );
  }
}
