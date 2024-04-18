import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:music_app/api/api.dart';
import 'package:music_app/extension/l10n.dart';
import 'package:music_app/main.dart';
import 'package:music_app/utils/flutter_toast.dart';
import 'package:music_app/utils/formatter.dart';
import 'package:music_app/widgets/no_artwork_cube.dart';

class SongBar extends StatelessWidget {
  SongBar(
    this.song,
    this.clearPlaylist, {
    this.showMusicDuration = false,
    this.onPlay,
    this.onRemove,
    super.key,
  });

  final dynamic song;
  final bool clearPlaylist;
  final VoidCallback? onRemove;
  final VoidCallback? onPlay;
  final bool showMusicDuration;

  static const likeStatusToIconMapper = {
    true: FluentIcons.star_24_filled,
    false: FluentIcons.star_24_regular,
  };

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onPlay ??
            () async {
              await audioHandler.playSong(song);
              if (activePlaylist.isNotEmpty && clearPlaylist) {
                activePlaylist = {
                  'ytid': '',
                  'title': 'No Playlist',
                  'header_desc': '',
                  'image': '',
                  'list': [],
                };
                id = 0;
              }
            },
        child: Card(
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                _buildAlbumArt(),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        song['title'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        song['artist'].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(context, primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {
    const size = 60.0;
    const radius = 12.0;

    final bool isOffline = song['isOffline'] ?? false;
    final String? artworkPath = song['artworkPath'];
    if (isOffline && artworkPath != null) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.file(
            File(artworkPath),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return CachedNetworkImage(
        key: Key(song['ytid'].toString()),
        width: size,
        height: size,
        imageUrl: song['lowResImage'].toString(),
        imageBuilder: (context, imageProvider) => SizedBox(
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image(
              image: imageProvider,
              centerSlice: const Rect.fromLTRB(1, 1, 1, 1),
            ),
          ),
        ),
        errorWidget: (context, url, error) => const NullArtworkWidget(
          iconSize: 30,
        ),
      );
    }
  }

  Widget _buildActionButtons(BuildContext context, Color primaryColor) {
    final songLikeStatus =
        ValueNotifier<bool>(isSongAlreadyLiked(song['ytid']));
    final songOfflineStatus =
        ValueNotifier<bool>(isSongAlreadyOffline(song['ytid']));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: songLikeStatus,
          builder: (_, value, __) {
            return IconButton(
              color: primaryColor,
              icon: Icon(likeStatusToIconMapper[value]),
              onPressed: () {
                songLikeStatus.value = !songLikeStatus.value;
                updateSongLikeStatus(
                  song['ytid'],
                  songLikeStatus.value,
                );
                final likedSongsLength = currentLikedSongsLength.value;
                currentLikedSongsLength.value =
                    value ? likedSongsLength + 1 : likedSongsLength - 1;
              },
            );
          },
        ),
        if (onRemove != null)
          IconButton(
            color: primaryColor,
            icon: const Icon(FluentIcons.list_bar_16_regular),
            onPressed: () => onRemove!(),
          )
        else
          IconButton(
            color: primaryColor,
            icon: const Icon(FluentIcons.library_16_filled),
            onPressed: () => showAddToPlaylistDialog(context, song),
          ),
        ValueListenableBuilder<bool>(
          valueListenable: songOfflineStatus,
          builder: (_, value, __) {
            return IconButton(
              color: primaryColor,
              icon: Icon(value
                  ? FluentIcons.arrow_download_16_regular
                  : FluentIcons.arrow_download_off_16_filled),
              onPressed: () {
                if (value) {
                  removeSongFromOffline(song['ytid']);
                } else {
                  makeSongOffline(song);
                }

                songOfflineStatus.value = !songOfflineStatus.value;
              },
            );
          },
        ),
        if (showMusicDuration && song['duration'] != null)
          Text('(${formatDuration(song['duration'])})'),
      ],
    );
  }
}

void showAddToPlaylistDialog(BuildContext context, dynamic song) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          context.l10n!.addToPlaylist,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final playlist in userCustomPlaylists)
              Card(
                child: ListTile(
                  title: Text(playlist['title']),
                  onTap: () {
                    addSongInCustomPlaylist(playlist['title'], song);
                    showToast(context, context.l10n!.songAdded);
                    Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
      );
    },
  );
}
