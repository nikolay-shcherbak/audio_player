import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/utils.dart';

class Markers extends StatefulWidget {
  const Markers({super.key, required this.player});
  final AudioPlayer player;

  @override
  State<Markers> createState() => _MarkersState();
}

class _MarkersState extends State<Markers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: widget.player.sequenceStateStream,
      builder: (context, snapshot) {
        final width = MediaQuery.of(context).size.width - 50;
        var state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag;
        final markers = metadata?.extras?['markers'] ?? [];

        if (markers.isNotEmpty) {
          return StreamBuilder<Duration?>(
              stream: widget.player.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return Stack(
                  children: markers
                      .map<Widget>(
                        (marker) => marker != 0
                            ? Container(
                                padding: EdgeInsets.only(
                                  left: getPosition(
                                      marker, duration.inSeconds, width),
                                ),
                                child: Container(
                                    height: 10,
                                    width: 3,
                                    color: Colors.black26),
                              )
                            : Container(),
                      )
                      .toList(),
                );
              });
        } else {
          return Container();
        }
      },
    );
  }
}
