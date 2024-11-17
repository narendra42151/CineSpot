import 'package:flutter/material.dart';

class EpisodesSection extends StatelessWidget {
  final List<dynamic> episodes;

  const EpisodesSection({
    Key? key,
    required this.episodes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Episodes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final episode = episodes[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16),
                child: Card(
                  color: Colors.grey[900],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (episode['image'] != null)
                        Image.network(
                          episode['image']['medium'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Episode ${episode['number']}: ${episode['name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (episode['runtime'] != null)
                              Text(
                                '${episode['runtime']} min',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                          ],
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
