import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/markers.dart';
import 'package:music/types.dart';
import 'package:music/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart';

class CustomSlider extends StatelessWidget {
  final AudioPlayer player;
  final setMarker;

  const CustomSlider(this.player, this.setMarker, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return StreamBuilder<PositionData>(
          stream: Rx.combineLatest2<Duration, Duration, PositionData>(
              player.positionStream,
              player.bufferedPositionStream,
              (position, bufferedPosition) =>
                  PositionData(position, bufferedPosition)),
          builder: (context, snapshot) {
            final positionData =
                snapshot.data ?? PositionData(Duration.zero, Duration.zero);
            var position = positionData.position;
            if (position > duration) {
              position = duration;
            }
            var bufferedPosition = positionData.bufferedPosition;
            if (bufferedPosition > duration) {
              bufferedPosition = duration;
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 70,
                        child: Text(
                          formatDuration(
                            position,
                          ),
                        ),
                      ),
                      StreamBuilder<bool>(
                        stream: player.shuffleModeEnabledStream,
                        builder: (context, snapshot) {
                          final shuffleModeEnabled = snapshot.data ?? false;
                          return IconButton(
                            icon: shuffleModeEnabled
                                ? const Icon(Icons.shuffle,
                                    color: Colors.orange)
                                : const Icon(Icons.shuffle, color: Colors.grey),
                            onPressed: () async {
                              final enable = !shuffleModeEnabled;
                              if (enable) {
                                await player.shuffle();
                              }
                              await player.setShuffleModeEnabled(enable);
                            },
                          );
                        },
                      ),
                      StreamBuilder<LoopMode>(
                        stream: player.loopModeStream,
                        builder: (context, snapshot) {
                          final loopMode = snapshot.data ?? LoopMode.off;
                          const icons = [
                            Icon(Icons.repeat, color: Colors.grey),
                            Icon(Icons.repeat, color: Colors.orange),
                            Icon(Icons.repeat_one, color: Colors.orange),
                          ];
                          const cycleModes = [
                            LoopMode.off,
                            LoopMode.all,
                            LoopMode.one,
                          ];
                          final index = cycleModes.indexOf(loopMode);
                          return IconButton(
                            icon: icons[index],
                            onPressed: () {
                              player.setLoopMode(cycleModes[
                                  (cycleModes.indexOf(loopMode) + 1) %
                                      cycleModes.length]);
                            },
                          );
                        },
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: 70,
                        child: Text(
                          formatDuration(duration - position),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    children: [
                      StreamBuilder<SequenceState?>(
                          stream: player.sequenceStateStream,
                          builder: (context, snapshot) {
                            var state = snapshot.data;
                            if (state?.sequence.isEmpty ?? true) {
                              return const SizedBox();
                            }
                            final metadata = state!.currentSource!.tag;
                            final markers = metadata?.extras?['markers'] ?? [];

                            return ProgressBar(
                              progress: position,
                              buffered: bufferedPosition,
                              total: duration,
                              onSeek: player.seek,
                              onDragUpdate: (details) {
                                if (markers.length > 0) {
                                  setMarker(markers, details.timeStamp);
                                }
                              },
                              barHeight: 10,
                              baseBarColor: Colors.grey,
                              progressBarColor: Colors.amber,
                              bufferedBarColor: Colors.white,
                              thumbColor: Colors.amber,
                              thumbGlowColor: Colors.amber,
                              // barCapShape: _barCapShape,
                              thumbRadius: 5,
                              // thumbCanPaintOutsideBar: _thumbCanPaintOutsideBar,
                              timeLabelLocation: TimeLabelLocation.none,
                              // timeLabelType: null,
                              // timeLabelTextStyle: _labelStyle,
                              timeLabelPadding: 10,
                            );
                          }),
                      Markers(player: player),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
