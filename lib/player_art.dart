import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/custom_box.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtSection extends StatelessWidget {
  final AudioPlayer player;

  const ArtSection(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) {
          var state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) {
            return const SizedBox();
          }
          final metadata = state!.currentSource!.tag;
          // log('${metadata.artwork}art');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomBox(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // child: Image.asset(
                    //   'assets/images/ri.jpeg',
                    //   fit: BoxFit.cover,
                    //   height: 350,
                    // ),
                    child: metadata?.extras?['dataId'] != null
                        ? QueryArtworkWidget(
                            id: metadata?.extras['dataId'],
                            type: ArtworkType.AUDIO,
                            artworkHeight: 350,
                            artworkWidth: double.infinity,
                            artworkBorder: BorderRadius.zero,
                          )
                        : metadata?.extras?['artwork'] != null
                            ? Image.network(
                                metadata.extras['artwork'],
                                fit: BoxFit.cover,
                                height: 350,
                              )
                            : metadata?.extras?['bytes'] != null
                                ? Image.memory(
                                    metadata.extras['bytes'],
                                    fit: BoxFit.cover,
                                    height: 350,
                                  )
                                : Image.asset(
                                    'assets/images/ri.jpeg',
                                    fit: BoxFit.cover,
                                    height: 350,
                                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 260,
                              height: 46,
                              child: Text(
                                metadata?.title ?? 'title',
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              metadata?.album ?? 'album',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
