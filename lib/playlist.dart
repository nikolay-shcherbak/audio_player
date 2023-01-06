import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

const assetsUri = '/audio/prince.mp3';
const networkUri =
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3';

final playlist = ConcatenatingAudioSource(
  useLazyPreparation: true,
  shuffleOrder: DefaultShuffleOrder(),
  children: [
    AudioSource.uri(
        Uri.parse(
            "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
        tag: const MediaItem(
          id: '1',
          title: 'Science Friday',
          album: 'Markers',
          extras: {
            'title': 'Science Friday',
            'album': 'Markers',
            'markers': [0, 150, 470, 700, 2000, 4000],
            'artwork':
                "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
          },
        )),
    ClippingAudioSource(
      start: const Duration(seconds: 0),
      end: const Duration(seconds: 30),
      child: AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
      tag: const MediaItem(
          id: '2',
          album: "Science Friday",
          title: "A Salute To Head-Scratching Science (Part 1)",
          extras: {
            'artwork':
                "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
          }),
    ),
    ClippingAudioSource(
      start: const Duration(seconds: 30),
      end: const Duration(seconds: 60),
      child: AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
      tag: const MediaItem(
          id: '3',
          album: "Science Friday",
          title: "A Salute To Head-Scratching Science (Part 2)",
          extras: {
            'artwork':
                "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
          }),
    ),
    ClippingAudioSource(
      start: const Duration(seconds: 60),
      end: const Duration(seconds: 90),
      child: AudioSource.uri(Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
      tag: const MediaItem(
          id: '4',
          album: "Science Friday",
          title: "A Salute To Head-Scratching Science (Part 3)",
          extras: {
            'artwork':
                "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
          }),
    ),
    AudioSource.uri(
      Uri.parse("asset:///assets/audio/prince.mp3"),
      tag: const MediaItem(
        id: '5',
        title: 'Prince Karma',
        album: 'Later',
      ),
    ),
    AudioSource.uri(
      Uri.parse("asset:///assets/audio/disel-power.mp3"),
      tag: const MediaItem(
        id: '6',
        title: 'Disel power',
        album: 'Pro',
      ),
    ),
    AudioSource.uri(
      Uri.parse("asset:///assets/audio/nightwish-wishmaster(mp3bit.cc).mp3"),
      tag: const MediaItem(
        id: '7',
        title: 'Nightwish',
        album: 'Wishmaster',
      ),
    ),
    AudioSource.uri(
      Uri.parse("asset:///assets/audio/Superfunk-TheYoungMC.mp3"),
      tag: const MediaItem(
        id: '8',
        title: 'Superfunk',
        album: 'TheYoungMC',
      ),
    ),
  ],
);
