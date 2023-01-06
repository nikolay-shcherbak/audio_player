import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/playlist.dart';
import 'package:music/track_page.dart';
import 'package:music/utils.dart';

import 'file_picker.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.player});
  final AudioPlayer player;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Center(child: Text('My playlist')),
        backgroundColor: Colors.deepOrange,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            child: const Text(
              '-',
              style: TextStyle(fontSize: 42),
            ),
            onTap: () async {
              await playlist.removeRange(0, playlist.length);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  pickSong();
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const FilePickerPage();
                        // return const IosPickerPage();
                        // return const PickAudioPage();
                      },
                    ),
                  );
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: double.maxFinite,
        child: StreamBuilder<SequenceState?>(
          stream: widget.player.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            final sequence = state?.sequence ?? [];

            if (sequence.isEmpty) {
              return const Center(
                child: Text('No songs in the Assets'),
              );
            } else {
              return ListView.builder(
                itemCount: sequence.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: widget.player.currentIndex == index &&
                              widget.player.playing
                          ? Colors.blueAccent
                          : Colors.deepOrange,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: ListTile(
                      title: Text(sequence[index].tag?.title ?? 'title'),
                      subtitle: Text(sequence[index].tag?.album ?? 'album'),
                      leading: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.audiotrack,
                          size: 32,
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(0),
                        child: GestureDetector(
                          onTap: () async {
                            await playlist.removeAt(index);
                          },
                          child: const Icon(
                            Icons.delete,
                            size: 32,
                          ),
                        ),
                      ),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return TrackPage(
                                  player: widget.player, index: index);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
