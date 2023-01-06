import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/control_button.dart';

class MarkersController extends StatefulWidget {
  final AudioPlayer player;
  final currentMarker;
  final getPrev;
  final getNext;
  const MarkersController({
    super.key,
    required this.player,
    required this.currentMarker,
    required this.getPrev,
    required this.getNext,
  });

  @override
  State<MarkersController> createState() => _MarkersControllerState();
}

class _MarkersControllerState extends State<MarkersController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: StreamBuilder<SequenceState?>(
          stream: widget.player.sequenceStateStream,
          builder: (context, snapshot) {
            var state = snapshot.data;
            if (state?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final metadata = state!.currentSource!.tag;
            final markers = metadata?.extras?['markers'] ?? [];
            if (markers.isEmpty) {
              return const SizedBox(
                height: 48,
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Custombutton(
                    size: 0,
                    disabled: widget.currentMarker == 0,
                    onPressed: () {
                      if (widget.currentMarker > 0) {
                        widget.player.seek(Duration(
                            seconds: markers[widget.currentMarker - 1]));
                        widget.getPrev();
                      }
                    },
                    child: const Center(
                      child: Text(
                        'prev marker',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Custombutton(
                    disabled: markers.length == widget.currentMarker + 1,
                    size: 0,
                    onPressed: () {
                      if (markers.length > widget.currentMarker + 1) {
                        widget.player.seek(Duration(
                            seconds: markers[widget.currentMarker + 1]));
                        widget.getNext();
                      }
                    },
                    child: const Text(
                      'next marker',
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
