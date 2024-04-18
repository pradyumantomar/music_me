import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:music_app/api/api.dart';
import 'package:music_app/extension/l10n.dart';
import 'package:music_app/main.dart';
import 'package:music_app/screens/playlist_page.dart';
import 'package:music_app/utils/flutter_toast.dart';
import 'package:music_app/widgets/confirmation_dialog.dart';
import 'package:music_app/widgets/playlist_cube.dart';
import 'package:music_app/widgets/spinner.dart';

class UserPlaylistsPage extends StatefulWidget {
  const UserPlaylistsPage({super.key});

  @override
  State<UserPlaylistsPage> createState() => _UserPlaylistsPageState();
}

class _UserPlaylistsPageState extends State<UserPlaylistsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          context.l10n!.userPlaylists,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              var id = '';
              var customPlaylistName = '';
              String? imageUrl;
              String? description;

              return AlertDialog(
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        context.l10n!.customPlaylistAddInstruction,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: context.l10n!.youtubePlaylistID,
                        ),
                        onChanged: (value) {
                          id = value;
                        },
                      ),
                      const SizedBox(height: 7),
                      TextField(
                        decoration: InputDecoration(
                          labelText: context.l10n!.customPlaylistName,
                        ),
                        onChanged: (value) {
                          customPlaylistName = value;
                        },
                      ),
                      const SizedBox(height: 7),
                      TextField(
                        decoration: InputDecoration(
                          labelText: context.l10n!.customPlaylistImgUrl,
                        ),
                        onChanged: (value) {
                          imageUrl = value;
                        },
                      ),
                      const SizedBox(height: 7),
                      TextField(
                        decoration: InputDecoration(
                          labelText: context.l10n!.customPlaylistDesc,
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      context.l10n!.add.toUpperCase(),
                    ),
                    onPressed: () async {
                      if (id.isNotEmpty) {
                        showToast(context, await addUserPlaylist(id, context));
                      } else if (customPlaylistName.isNotEmpty) {
                        showToast(
                          context,
                          createCustomPlaylist(
                            customPlaylistName,
                            imageUrl,
                            description,
                            context,
                          ),
                        );
                      } else {
                        showToast(
                          context,
                          '${context.l10n!.provideIdOrNameError}.',
                        );
                      }

                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          FluentIcons.add_24_filled,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getUserPlaylists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Spinner();
                } else if (snapshot.hasError) {
                  logger.log(
                    'Error on user playlists page',
                    snapshot.error,
                    snapshot.stackTrace,
                  );
                  return Center(
                    child: Text(context.l10n!.error),
                  );
                }

                final _playlists = snapshot.data as List;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: _playlists.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, index) {
                    final playlist = _playlists[index];
                    final ytid = playlist['ytid'];

                    return GestureDetector(
                      onTap: playlist['isCustom'] ?? false
                          ? () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlaylistPage(playlistData: playlist),
                                ),
                              );
                              if (result == false) {
                                setState(() {});
                              }
                            }
                          : null,
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationDialog(
                              confirmationMessage:
                                  context.l10n!.removePlaylistQuestion,
                              submitMessage: context.l10n!.remove,
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                              onSubmit: () {
                                Navigator.of(context).pop();

                                if (ytid == null && playlist['isCustom']) {
                                  removeUserCustomPlaylist(playlist);
                                } else {
                                  removeUserPlaylist(ytid);
                                }

                                setState(() {});
                              },
                            );
                          },
                        );
                      },
                      child: PlaylistCube(
                        id: ytid,
                        image: playlist['image'],
                        title: playlist['title'],
                        playlistData:
                            playlist['isCustom'] ?? false ? playlist : null,
                        onClickOpen: playlist['isCustom'] == null,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
