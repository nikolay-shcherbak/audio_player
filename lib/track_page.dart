import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/player_art.dart';
import 'package:music/player_controller.dart';
import 'package:music/player_slider.dart';
import 'package:music/playlist_header.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({Key? key, required this.player, required this.index})
      : super(key: key);

  final AudioPlayer player;
  final int index;

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  @override
  void initState() {
    super.initState();

    initPlayer();
  }

  void initPlayer() {
    if (widget.player.currentIndex != widget.index ||
        widget.player.playing == false) {
      widget.player.seek(Duration.zero, index: widget.index);
      widget.player.play();
    }
  }

  int currentMarker = 0;

  void getNext() {
    setState(() {
      currentMarker++;
    });
  }

  void getPrev() {
    setState(() {
      currentMarker--;
    });
  }

  void refreshMarkers() {
    setState(() {
      currentMarker = 0;
    });
  }

  void setMarker(List<int> markers, position) {
    log(markers.toString());
    log(position.toString());
    setState(() {
      currentMarker = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const PlaylistHeader(),
              const SizedBox(height: 20),
              ArtSection(widget.player),
              const SizedBox(height: 20),
              CustomSlider(widget.player, setMarker),
              const SizedBox(height: 20),
              ControlButtons(
                player: widget.player,
                currentMarker: currentMarker,
                getNext: getNext,
                getPrev: getPrev,
                refreshMarkers: refreshMarkers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
