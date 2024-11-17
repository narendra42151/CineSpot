import 'package:flutter/material.dart';

class FeaturedContent extends StatelessWidget {
  final dynamic movie;

  const FeaturedContent({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 500,
          decoration: BoxDecoration(
            image: movie['image'] != null
                ? DecorationImage(
                    image: NetworkImage(movie['image']['original']),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.transparent,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.2, 0.8, 1],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                if (movie['name'] != null)
                  Text(
                    movie['name'],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
                if (movie['genres'] != null)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: movie['genres'].map<Widget>((genre) {
                      return Text(
                        genre,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
