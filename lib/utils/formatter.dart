import 'package:youtube_explode_dart/youtube_explode_dart.dart';

String formatSongTitle(String title) {
  final replacements = {
    '[': '',
    ']': '',
    '(': '',
    ')': '',
    '|': '',
    '&amp;': '&',
    '&#039;': "'",
    '&quot;': '"',
    'Official Music Video': '',
    'Official Lyric Video': '',
    'Official Video': '',
    'Official Audio': '',
    'Lyric Video': '',
    'Lyrics Video': '',
  };

  final pattern = RegExp(replacements.keys.map(RegExp.escape).join('|'));

  return title
      .replaceAllMapped(pattern, (match) => replacements[match.group(0)] ?? '')
      .trimLeft();
}

Map<String, dynamic> returnSongLayout(int index, Video song) => {
      'id': index,
      'ytid': song.id.toString(),
      'title': formatSongTitle(
        song.title.split('-')[song.title.split('-').length - 1],
      ),
      'artist': song.title.split('-')[0],
      'image': song.thumbnails.standardResUrl,
      'lowResImage': song.thumbnails.lowResUrl,
      'highResImage': song.thumbnails.highResUrl,
      'duration': song.duration?.inSeconds,
      'isLive': song.isLive,
    };

String formatDuration(int audioDurationInSeconds) {
  final duration = Duration(seconds: audioDurationInSeconds);

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  var formattedDuration = '';

  if (hours > 0) {
    formattedDuration += '${hours.toString().padLeft(2, '0')}:';
  }

  formattedDuration += '${minutes.toString().padLeft(2, '0')}:';
  formattedDuration += seconds.toString().padLeft(2, '0');

  return formattedDuration;
}
