import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/playlist.dart';

String formatDuration(Duration duration) {
  // ignore: unnecessary_null_comparison
  if (duration == null) {
    return '0';
  }
  double hoursCount = duration.inHours.remainder(60);
  String hours = hoursCount > 0
      ? '${duration.inHours.remainder(60).toString().padLeft(2, '')}:'
      : '   ';
  String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "$hours$minutes:$seconds";
}

double getPosition(int marker, int duration, double width) {
  return width / duration * marker;
}

Future pickSong() async {
  FilePicker.platform.pickFiles(withReadStream: true, type: FileType.audio)
    ..then(
      (result) {
        if (result == null) return;
        if (result.count == 0) return;
        if (kIsWeb) {
          /// Use [MetadataRetriever.fromBytes] on Web.
          MetadataRetriever.fromBytes(
            result.files.first.bytes!,
          )
            ..then(
              (metadata) {
                // showData(metadata);
              },
            )
            ..catchError((_) {});
        } else {
          MetadataRetriever.fromFile(
            File(result.files.first.path!),
          )
            ..then(
              (metadata) {
                log(metadata.albumArt.toString());
                addSong(metadata, metadata.albumArt);
              },
            )
            ..catchError((_) {});
        }
      },
    )
    ..catchError((_) {});
}

Future addSong(metadata, Uint8List? art) async {
  log('${art}ww');
  log(metadata.toString());
  playlist.add(
    AudioSource.uri(
      Uri.file(metadata.filePath!),
      tag: MediaItem(
          id: (playlist.length + 1).toString(),
          title: metadata.trackName,
          album: metadata.albumName ?? metadata.trackArtistNames.first ?? '',
          extras: {
            'bytes': art,
          }),
    ),
  );
}
