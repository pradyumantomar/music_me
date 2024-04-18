import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:music_app/api/api.dart';
import 'package:music_app/extension/l10n.dart';
import 'package:music_app/main.dart';
import 'package:music_app/widgets/playlist_cube.dart';
import 'package:music_app/widgets/playlist_header.dart';
import 'package:music_app/widgets/song_bar.dart';

class UserSongsPage extends StatefulWidget {
  const UserSongsPage({
    super.key,
    required this.page,
  });

  final String page;

  @override
  State<UserSongsPage> createState() => _UserSongsPageState();
}

class _UserSongsPageState extends State<UserSongsPage> {
  bool isEditEnabled = false;

  @override
  Widget build(BuildContext context) {
    final title = getTitle(widget.page, context);
    final icon = getIcon(widget.page);
    final songsList = getSongsList(widget.page);
    final length = getLength(widget.page);

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (title == context.l10n!.userLikedSongs)
            IconButton(
              onPressed: () {
                setState(() {
                  isEditEnabled = !isEditEnabled;
                });
              },
              icon: Icon(
                FluentIcons.re_order_24_filled,
                color: isEditEnabled
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
      body: _buildCustomScrollView(title, icon, songsList, length),
    );
  }

  Widget _buildCustomScrollView(
    String title,
    IconData icon,
    List songsList,
    ValueNotifier length,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: buildPlaylistHeader(title, icon, songsList.length),
          ),
        ),
        buildSongList(title, songsList, length),
      ],
    );
  }

  String getTitle(String page, BuildContext context) {
    return {
          'liked': context.l10n!.userLikedSongs,
          'offline': context.l10n!.userOfflineSongs,
        }[page] ??
        context.l10n!.playlist;
  }

  IconData getIcon(String page) {
    return {
          'liked': FluentIcons.heart_24_regular,
          'offline': FluentIcons.cellular_off_24_regular,
        }[page] ??
        FluentIcons.heart_24_regular;
  }

  List getSongsList(String page) {
    return {
          'liked': userLikedSongsList,
          'offline': userOfflineSongs,
        }[page] ??
        userLikedSongsList;
  }

  ValueNotifier getLength(String page) {
    return {
          'liked': currentLikedSongsLength,
          'offline': currentOfflineSongsLength,
        }[page] ??
        currentLikedSongsLength;
  }

  Widget buildPlaylistHeader(String title, IconData icon, int songsLength) {
    return PlaylistHeader(
      _buildPlaylistImage(title, icon),
      title,
      null,
      songsLength,
    );
  }

  Widget _buildPlaylistImage(String title, IconData icon) {
    return PlaylistCube(
      title: title,
      onClickOpen: false,
      showFavoriteButton: false,
      size: MediaQuery.of(context).size.width / 2.5,
      cubeIcon: icon,
    );
  }

  Widget buildSongList(
    String title,
    List songsList,
    ValueNotifier currentSongsLength,
  ) {
    final _playlist = {
      'ytid': '',
      'title': title,
      'list': songsList,
    };
    return ValueListenableBuilder(
      valueListenable: currentSongsLength,
      builder: (_, value, __) {
        if (title == context.l10n!.userLikedSongs) {
          return SliverReorderableList(
            itemCount: songsList.length,
            itemBuilder: (context, index) {
              final song = songsList[index];

              return ReorderableDragStartListener(
                enabled: isEditEnabled,
                key: Key(song['ytid'].toString()),
                index: index,
                child: SongBar(
                  song,
                  true,
                  onPlay: () => {
                    audioHandler.playPlaylistSong(
                      playlist: activePlaylist != _playlist ? _playlist : null,
                      songIndex: index,
                    ),
                  },
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                moveLikedSong(oldIndex, newIndex);
              });
            },
          );
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final song = songsList[index];
                song['isOffline'] = title == context.l10n!.userOfflineSongs;
                return SongBar(
                  song,
                  true,
                  onPlay: () => {
                    audioHandler.playPlaylistSong(
                      playlist: activePlaylist != _playlist ? _playlist : null,
                      songIndex: index,
                    ),
                  },
                );
              },
              childCount: songsList.length,
            ),
          );
        }
      },
    );
  }
}
