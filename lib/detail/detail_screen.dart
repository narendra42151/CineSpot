import 'package:cinespot/widget/InfoRow.dart';
import 'package:cinespot/widget/episode_section.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final dynamic movie;

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isInMyList = false;
  bool isLiked = false;
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    setState(() {
      _opacity = (offset / 200).clamp(0, 1);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Movie Poster
                      widget.movie['image'] != null
                          ? Image.network(
                              widget.movie['image']['original'],
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[900],
                              child: const Center(
                                child: Icon(Icons.movie,
                                    size: 100, color: Colors.white),
                              ),
                            ),
                      // Gradient overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Rating
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.movie['name'],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (widget.movie['rating'] != null &&
                                  widget.movie['rating']['average'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.movie['rating']['average']
                                            .toString(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(120, 45),
                                ),
                                onPressed: () {},
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.play_arrow),
                                    SizedBox(width: 4),
                                    Text('Play'),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                  minimumSize: const Size(120, 45),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isInMyList = !isInMyList;
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isInMyList ? Icons.check : Icons.add,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('My List'),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isLiked
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLiked = !isLiked;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Genres
                          if (widget.movie['genres'] != null &&
                              widget.movie['genres'].isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (var genre in widget.movie['genres'])
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      genre,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 16),

                          // Summary
                          if (widget.movie['summary'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Overview',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.movie['summary']
                                      .replaceAll(RegExp(r'<[^>]*>'), ''),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          const SizedBox(height: 24),

                          // Show Info
                          if (widget.movie['status'] != null ||
                              widget.movie['premiered'] != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Show Info',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (widget.movie['status'] != null)
                                  InfoRow(
                                    label: 'Status',
                                    value: widget.movie['status'],
                                  ),
                                if (widget.movie['premiered'] != null)
                                  InfoRow(
                                    label: 'Premiered',
                                    value: widget.movie['premiered'],
                                  ),
                                if (widget.movie['language'] != null)
                                  InfoRow(
                                    label: 'Language',
                                    value: widget.movie['language'],
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Episodes Section (if available)
                    if (widget.movie['_embedded']?['episodes'] != null)
                      EpisodesSection(
                          episodes: widget.movie['_embedded']['episodes']),
                  ],
                ),
              ),
            ],
          ),
          // Floating back button with dynamic opacity
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(_opacity),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
