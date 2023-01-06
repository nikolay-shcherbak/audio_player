import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:better_audio_picker_plugin/better_audio_picker_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:id3/id3.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/playlist.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';

class PickAudioPage extends StatefulWidget {
  const PickAudioPage({super.key});

  @override
  State<PickAudioPage> createState() => _PickAudioPageState();
}

class _PickAudioPageState extends State<PickAudioPage> {
  late BetterAudioPickerPlugin audioPickerPlugin;
  late StreamSubscription scanResultStreamSubscription;
  late StreamSubscription pickResultStreamSubscription;

  List<BetterAudioPickerPluginAudioModel> audioList = [];
  List<int> selectedSongs = [];
  late Directory tempDirectory;

  Future addSong(int index, BetterAudioPickerPluginAudioModel audio) async {
    if (!selectedSongs.contains(index)) {
      setState(() {
        selectedSongs.add(index);
      });

      String tempPath = path.join(tempDirectory.path, audio.name);
      List<int> mp3Bytes = File(tempPath).readAsBytesSync();
      MP3Instance mp3instance = MP3Instance(mp3Bytes);

      if (mp3Bytes.isNotEmpty && mp3instance.parseTagsSync()) {
        mp3instance.getMetaTags();
        var apic = mp3instance.metaTags['APIC'];
        String title = (mp3instance.metaTags['Title']);
        var album = (mp3instance.metaTags['Album']);
        Uint8List bytes = const Base64Decoder().convert(apic.values.last);
        log(audio.uri);
        playlist.add(AudioSource.uri(Uri.parse(audio.uri),
            tag: MediaItem(
              id: (playlist.length + 1).toString(),
              title: title,
              album: album,
              extras: {
                'bytes': bytes,
              },
            )));
      }
    }
  }

  Future saveFileTemp(PlatformFile file) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final newFile = File('${appDocDir.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  @override
  void initState() {
    super.initState();

    audioPickerPlugin = BetterAudioPickerPlugin();
    scanResultStreamSubscription =
        audioPickerPlugin.scanResultStream.listen((event) {
      log("Succes: $event");
      setState(() {
        audioList = event;
      });
      for (var e in event) {
        log(e.toString());
        final tempPath = path.join(tempDirectory.path, e.name);
        audioPickerPlugin.pickAudio(uri: e.uri, path: tempPath);
      }
    });
    audioPickerPlugin.scanAudio();
    pickResultStreamSubscription =
        audioPickerPlugin.pickResultStream.listen((event) {
      log("音频保存路径：$event");
    });

    Future setDirectory() async {
      var dir = await getTemporaryDirectory();
      setState(() {
        tempDirectory = dir;
      });
    }

    setDirectory();

    Future.delayed(Duration.zero, () async {
      if (await Permission.storage.isGranted) {
      } else if (!(await Permission.storage.isPermanentlyDenied)) {
        final status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          audioPickerPlugin.scanAudio();
        } else {
          openAppSettings();
        }
      } else {
        openAppSettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Center(child: Text('My audio')),
        backgroundColor: Colors.deepOrange,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              child: const Text('Add all'),
              onTap: () async {
                Navigator.of(context).pop();
                for (var i = 0; i < audioList.length; i++) {
                  addSong(i, audioList[i]);
                }
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final audio = audioList[index];
            return Container(
              margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: selectedSongs.contains(index)
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
                title: Text(audio.name),
                leading: const Icon(Icons.audiotrack),
                onTap: () async {
                  await addSong(index, audio);
                },
              ),
            );
          },
          itemCount: audioList.length),
    );
  }
}
