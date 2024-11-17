import 'dart:convert';

import 'package:cinespot/detail/detail_screen.dart';
import 'package:cinespot/screens/search/search_screen.dart';
import 'package:cinespot/widget/content_list.dart';
import 'package:cinespot/widget/featured_contnet.dart';
import 'package:cinespot/widget/play_button.dart';
import 'package:cinespot/widget/preview_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:svg_flutter/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> movies = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  Map<String, List<dynamic>> moviesByGenre = {};
  dynamic featuredMovie;

  @override
  void initState() {
    super.initState();
    fetchMovies();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      final List<dynamic> fetchedMovies = json.decode(response.body);

      Map<String, List<dynamic>> tempMoviesByGenre = {};

      for (var movieData in fetchedMovies) {
        var movie = movieData['show'];
        if (movie['genres'] != null) {
          for (var genre in movie['genres']) {
            if (!tempMoviesByGenre.containsKey(genre)) {
              tempMoviesByGenre[genre] = [];
            }
            tempMoviesByGenre[genre]!.add(movie);
          }
        }
      }

      setState(() {
        movies = fetchedMovies;
        moviesByGenre = tempMoviesByGenre;
        featuredMovie = fetchedMovies[0]['show'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double opacity = (_scrollOffset / 350).clamp(0, 1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.black.withOpacity(opacity),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 90,
              width: 100,
              child: SvgPicture.asset(
                "assets/images/Logo1.svg",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.cast),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: FeaturedContent(
                    movie: featuredMovie,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PreviewButton(
                          icon: Icons.add,
                          title: 'My List',
                          onTap: () {},
                        ),
                        const PlayButton(),
                        PreviewButton(
                          icon: Icons.info_outline,
                          title: 'Info',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(movie: featuredMovie),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                for (var genre in moviesByGenre.keys)
                  if (moviesByGenre[genre]!.isNotEmpty)
                    SliverToBoxAdapter(
                      child: ContentList(
                        title: genre,
                        movies: moviesByGenre[genre]!,
                      ),
                    ),
              ],
            ),
    );
  }
}
