import 'package:cinespot/detail/detail_screen.dart';
import 'package:flutter/material.dart';

class ContentList extends StatelessWidget {
  final String title;
  final List<dynamic> movies;

  const ContentList({
    Key? key,
    required this.title,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(movie: movie),
                    ),
                  );
                },
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: movie['image'] != null
                                ? DecorationImage(
                                    image:
                                        NetworkImage(movie['image']['medium']),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: movie['image'] == null
                              ? const Center(
                                  child: Icon(
                                    Icons.movie,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie['name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
