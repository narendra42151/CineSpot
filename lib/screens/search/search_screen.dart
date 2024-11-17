// lib/screens/search_screen.dart
import 'dart:convert';

import 'package:cinespot/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.tvmaze.com/search/shows?q=$query'),
      );

      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error - you might want to show a snackbar or error message
    }
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final movie = searchResults[index]['show'];
        return _MovieCard(movie: movie);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            searchMovies(value);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildSearchResults(),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final dynamic movie;

  const _MovieCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(movie: movie),
          ),
        );
      },
      child: Card(
        color: Colors.grey[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _MovieImage(imageUrl: movie['image']?['medium']),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie['name'] ?? 'Unknown Title',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieImage extends StatelessWidget {
  final String? imageUrl;

  const _MovieImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Icon(Icons.movie, size: 50, color: Colors.white),
        ),
      );
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey,
          child: const Center(
            child: Icon(Icons.error, size: 50, color: Colors.white),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
