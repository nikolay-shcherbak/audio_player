import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/control_button.dart';
import 'package:music/markers_controlles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons(
      {super.key,
      required this.player,
      required this.getNext,
      required this.getPrev,
      required this.currentMarker,
      required this.refreshMarkers});
  final AudioPlayer player;
  final getNext;
  final getPrev;
  final currentMarker;
  final refreshMarkers;

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class ControlButtons extends StatelessWidget {
//   final AudioPlayer player;

//   const ControlButtons(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          MarkersController(
            player: widget.player,
            currentMarker: widget.currentMarker,
            getPrev: widget.getPrev,
            getNext: widget.getNext,
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                StreamBuilder<SequenceState?>(
                  stream: widget.player.sequenceStateStream,
                  builder: (context, snapshot) => Expanded(
                    child: Custombutton(
                      disabled: !widget.player.hasPrevious,
                      onPressed: () {
                        if (widget.player.hasPrevious) {
                          widget.player.seekToPrevious();
                          widget.refreshMarkers();
                        }
                      },
                      child: const Icon(
                        Icons.skip_previous,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: StreamBuilder<PlayerState>(
                      stream: widget.player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;

                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return Custombutton(
                            onPressed: () {},
                            disabled: true,
                            child: const Center(
                                child: SpinKitFadingCircle(
                              color: Colors.black,
                              size: 32,
                            )),
                          );
                        } else if (playing != true) {
                          return Custombutton(
                            onPressed: widget.player.play,
                            child: const Icon(
                              Icons.play_arrow,
                              size: 32,
                            ),
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return Custombutton(
                            onPressed: widget.player.pause,
                            child: const Icon(
                              Icons.pause,
                              size: 32,
                            ),
                          );
                        } else {
                          return Custombutton(
                            onPressed: () => widget.player.seek(Duration.zero,
                                index: widget.player.effectiveIndices!.first),
                            child: const Icon(
                              Icons.replay,
                              size: 32,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                StreamBuilder<SequenceState?>(
                  stream: widget.player.sequenceStateStream,
                  builder: (context, snapshot) => Expanded(
                    child: Custombutton(
                      disabled: !widget.player.hasNext,
                      onPressed: () {
                        if (widget.player.hasNext) {
                          widget.player.seekToNext();
                          widget.refreshMarkers();
                        }
                      },
                      child: const Icon(
                        Icons.skip_next,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
