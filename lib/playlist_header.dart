import 'package:flutter/material.dart';
import 'package:music/custom_box.dart';

class PlaylistHeader extends StatelessWidget {
  const PlaylistHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: CustomBox(
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          const Text('P L A Y L I S T'),
          SizedBox(
            height: 60,
            width: 60,
            child: CustomBox(
              child: IconButton(
                onPressed: () async {},
                icon: const Icon(Icons.menu),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
