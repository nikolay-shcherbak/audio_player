import 'dart:typed_data';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}

class AudioMetadata {
  String? album;
  String? title;
  String? artwork;
  Uint8List? bytes;
  int? dataId;
  List<int>? markers;
  String? path;
}
