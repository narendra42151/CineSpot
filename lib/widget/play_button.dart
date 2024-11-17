import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      ),
      onPressed: () {},
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow, size: 30),
          SizedBox(width: 4),
          Text(
            'Play',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
