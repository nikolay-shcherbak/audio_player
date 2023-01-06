import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class FilePickerPage extends StatefulWidget {
  const FilePickerPage({Key? key}) : super(key: key);

  @override
  FilePickerPageState createState() => FilePickerPageState();
}

class FilePickerPageState extends State<FilePickerPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<int> selectedSongs = [];

  @override
  void initState() {
    super.initState();
    // requestPermission();

    Future.delayed(Duration.zero, () async {
      if (await Permission.storage.isGranted) {
        _audioQuery.querySongs();
        log('message');
        setState(() {});
      } else if (!(await Permission.storage.isPermanentlyDenied)) {
        final status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          log('granted');
          _audioQuery.querySongs();
        } else {
          log('nope');
          openAppSettings();
        }
      } else {
        log('nope2');
        openAppSettings();
      }
    });
  }

  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My songs"),
        elevation: 2,
      ),
      body: FutureBuilder<List<SongModel>>(
        // Default values:
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          // uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          // Loading content
          if (item.data == null) return const CircularProgressIndicator();

          // When you try "query" without asking for [READ] or [Library] permission
          // the plugin will return a [Empty] list.
          if (item.data!.isEmpty) return const Text("Nothing found!");

          // You can use [item.data!] direct or you can create a:
          // List<SongModel> songs = item.data!;
          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return !selectedSongs.contains(index)
                  ? ListTile(
                      onTap: () {
                        if (!selectedSongs.contains(index)) {
                          setState(() {
                            selectedSongs.add(index);
                          });
                          var data = item.data![index];
                          log('${data.id}ee');
                          playlist.add(AudioSource.uri(Uri.parse(data.uri!),
                              tag: MediaItem(
                                  id: (playlist.length + 1).toString(),
                                  title: data.title,
                                  album: data.album,
                                  extras: {
                                    'dataId': data.id,
                                  })));
                        }
                      },
                      title: Text(item.data![index].title),
                      subtitle: Text(item.data![index].artist ?? "No Artist"),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      // This Widget will query/load image. Just add the id and type.
                      // You can use/create your own widget/method using [queryArtwork].
                      leading: QueryArtworkWidget(
                        id: item.data![index].id,
                        type: ArtworkType.AUDIO,
                      ),
                    )
                  : Container();
            },
          );
        },
      ),
    );
  }
}
