import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:music_app/api/api.dart';
import 'package:music_app/extension/l10n.dart';
import 'package:music_app/main.dart';
import 'package:music_app/screens/playlist_page.dart';
import 'package:music_app/screens/search_page.dart';
import 'package:music_app/services/data_manager.dart';
import 'package:music_app/services/router_service.dart';
import 'package:music_app/widgets/menu_list.dart';
import 'package:music_app/widgets/setting_switch_bar.dart';
import 'package:music_app/services/settings_manager.dart';
import 'package:music_app/style/app_colors.dart';
import 'package:music_app/style/app_theme.dart';
import 'package:music_app/utils/flutter_toast.dart';
import 'package:music_app/utils/url_launcher.dart';
import 'package:music_app/widgets/confirmation_dialog.dart';
import 'package:music_app/widgets/setting_bar.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  static const List<String> _fonts = [
    'Crimson Pro',
    'EB Garamond',
    'Fira Sans',
    'IBM Plex Sans',
    'IBM Plex Serif',
    'Inter',
    'Noto Sans',
    'Noto Serif',
    'Open Sans',
    'Roboto',
    'Roboto Serif',
    'Source Sans 3',
    'Source Serif 4',
  ];
  // String currentFont = getFont();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Settings',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // CATEGORY: PAGES
            // _buildSectionTitle(
            //   primaryColor,
            //   context.l10n!.pages,
            // ),
            SettingBar(
              context.l10n!.recentlyPlayed,
              FluentIcons.history_24_filled,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistPage(
                    playlistData: {
                      'title': context.l10n!.recentlyPlayed,
                      'list': userRecentlyPlayed,
                    },
                  ),
                ),
              ),
            ),
            // MenuListTile(
            //   title: Text('Font'),
            //   trailing: Text(_fonts.first),
            //   // onChanged: _settingsCubit.setFont,
            //   values: _fonts,
            //   selected: (value) {
            //     {
            //       debugPrint(value);
            //       addOrUpdateData(
            //         'settings',
            //         'fonts',
            //         value,
            //       );
            //     }
            //     ();
            //     return true;
            //   },
            //   childBuilder: Text.new,
            // ),
            SettingBar(
              context.l10n!.playlists,
              FluentIcons.list_24_filled,
              () => NavigationManager.router.go(
                '/more/playlists',
              ),
            ),
            SettingBar(
              context.l10n!.userLikedSongs,
              FluentIcons.heart_24_filled,
              () => NavigationManager.router.go(
                '/more/userSongs/liked',
              ),
            ),
            SettingBar(
              context.l10n!.userOfflineSongs,
              FluentIcons.cellular_off_24_filled,
              () => NavigationManager.router.go(
                '/more/userSongs/offline',
              ),
            ),
            SettingBar(
              context.l10n!.userLikedPlaylists,
              FluentIcons.star_24_filled,
              () => NavigationManager.router.go(
                '/more/userLikedPlaylists',
              ),
            ),

            // CATEGORY: SETTINGS
            // _buildSectionTitle(
            //   primaryColor,
            //   context.l10n!.settings,
            // ),
            SettingBar(
              context.l10n!.accentColor,
              FluentIcons.color_24_filled,
              () => showModalBottomSheet(
                isDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: availableColors.length,
                      itemBuilder: (context, index) {
                        final color = availableColors[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (availableColors.length > index)
                                GestureDetector(
                                  onTap: () {
                                    addOrUpdateData(
                                      'settings',
                                      'accentColor',
                                      color.value,
                                    );
                                    MusicApp.updateAppState(
                                      context,
                                      newAccentColor: color,
                                      useSystemColor: false,
                                    );
                                    showToast(
                                      context,
                                      context.l10n!.accentChangeMsg,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Material(
                                    elevation: 4,
                                    shape: const CircleBorder(),
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          themeMode == ThemeMode.light
                                              ? color.withAlpha(150)
                                              : color,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SettingBar(
              context.l10n!.themeMode,
              FluentIcons.weather_sunny_28_filled,
              () => showModalBottomSheet(
                isDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  final availableModes = [
                    ThemeMode.system,
                    ThemeMode.light,
                    ThemeMode.dark,
                  ];

                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: availableModes.length,
                      itemBuilder: (context, index) {
                        final mode = availableModes[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          elevation: themeMode == mode ? 0 : 4,
                          child: ListTile(
                            title: Text(
                              mode.name,
                            ),
                            onTap: () {
                              addOrUpdateData(
                                'settings',
                                'themeMode',
                                mode.name,
                              );
                              MusicApp.updateAppState(
                                context,
                                newThemeMode: mode,
                              );

                              Navigator.pop(context);
                            },
                            trailing: mode == ThemeMode.light ||
                                    mode == ThemeMode.system
                                ? const Text('BETA')
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SettingBar(
              context.l10n!.language,
              FluentIcons.translate_24_filled,
              () => showModalBottomSheet(
                isDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  final availableLanguages = appLanguages.keys.toList();
                  final activeLanguageCode =
                      Localizations.localeOf(context).languageCode;

                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: availableLanguages.length,
                      itemBuilder: (context, index) {
                        final language = availableLanguages[index];
                        final languageCode = appLanguages[language] ?? 'en';
                        return Card(
                          elevation: activeLanguageCode == languageCode ? 0 : 4,
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              language,
                            ),
                            onTap: () {
                              addOrUpdateData(
                                'settings',
                                'language',
                                language,
                              );
                              MusicApp.updateAppState(
                                context,
                                newLocale: Locale(
                                  languageCode,
                                ),
                              );

                              showToast(
                                context,
                                context.l10n!.languageMsg,
                              );
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SettingSwitchBar(
              tileName: context.l10n!.dynamicColor,
              tileIcon: FluentIcons.toggle_left_24_filled,
              value: useSystemColor.value,
              onChanged: (value) {
                addOrUpdateData(
                  'settings',
                  'useSystemColor',
                  value,
                );
                useSystemColor.value = value;
                MusicApp.updateAppState(
                  context,
                  newAccentColor: primaryColorSetting,
                  useSystemColor: value,
                );
                showToast(
                  context,
                  context.l10n!.settingChangedMsg,
                );
              },
            ),
            // ValueListenableBuilder<bool>(
            //   valueListenable: sponsorBlockSupport,
            //   builder: (_, value, __) {
            //     return SettingSwitchBar(
            //       tileName: 'SponsorBlock',
            //       tileIcon: FluentIcons.presence_blocked_24_regular,
            //       value: value,
            //       onChanged: (value) {
            //         addOrUpdateData(
            //           'settings',
            //           'sponsorBlockSupport',
            //           value,
            //         );
            //         sponsorBlockSupport.value = value;
            //         showToast(
            //           context,
            //           context.l10n!.settingChangedMsg,
            //         );
            //       },
            //     );
            //   },
            // ),

            SettingBar(
              context.l10n!.audioQuality,
              Icons.music_note,
              () {
                showModalBottomSheet(
                  isDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    final availableQualities = ['low', 'medium', 'high'];

                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: availableQualities.length,
                        itemBuilder: (context, index) {
                          final quality = availableQualities[index];
                          final isCurrentQuality =
                              audioQualitySetting.value == quality;

                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              elevation: isCurrentQuality ? 0 : 4,
                              child: ListTile(
                                title: Text(quality),
                                onTap: () {
                                  addOrUpdateData(
                                    'settings',
                                    'audioQuality',
                                    quality,
                                  );
                                  audioQualitySetting.value = quality;

                                  showToast(
                                    context,
                                    context.l10n!.audioQualityMsg,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),

            // // CATEGORY: TOOLS
            // _buildSectionTitle(
            //   primaryColor,
            //   context.l10n!.tools,
            // ),
            SettingBar(
              context.l10n!.clearCache,
              FluentIcons.broom_24_filled,
              () {
                clearCache();
                showToast(
                  context,
                  '${context.l10n!.cacheMsg}!',
                );
              },
            ),
            SettingBar(
                context.l10n!.clearSearchHistory, FluentIcons.history_24_filled,
                () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog(
                    submitMessage: context.l10n!.clear,
                    confirmationMessage:
                        context.l10n!.clearSearchHistoryQuestion,
                    onCancel: () => {Navigator.of(context).pop()},
                    onSubmit: () => {
                      Navigator.of(context).pop(),
                      searchHistory = [],
                      deleteData('user', 'searchHistory'),
                      showToast(context, '${context.l10n!.searchHistoryMsg}!'),
                    },
                  );
                },
              );
            }),
            SettingBar(
              context.l10n!.clearRecentlyPlayed,
              FluentIcons.receipt_play_24_filled,
              () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      submitMessage: context.l10n!.clear,
                      confirmationMessage:
                          context.l10n!.clearRecentlyPlayedQuestion,
                      onCancel: () => {Navigator.of(context).pop()},
                      onSubmit: () => {
                        Navigator.of(context).pop(),
                        userRecentlyPlayed = [],
                        deleteData('user', 'recentlyPlayedSongs'),
                        showToast(
                          context,
                          '${context.l10n!.recentlyPlayedMsg}!',
                        ),
                      },
                    );
                  },
                );
              },
            ),
            SettingBar(
              context.l10n!.backupUserData,
              FluentIcons.cloud_sync_24_filled,
              () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(context.l10n!.folderRestrictions),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            context.l10n!.understand.toUpperCase(),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
                final response = await backupData(context);
                showToast(context, response);
              },
            ),

            SettingBar(
              context.l10n!.restoreUserData,
              FluentIcons.cloud_add_24_filled,
              () async {
                final response = await restoreData(context);
                showToast(context, response);
              },
            ),

            // _buildSectionTitle(
            //   primaryColor,
            //   context.l10n!.becomeSponsor,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: Card(
            //     color: primaryColor,
            //     child: ListTile(
            //       leading: const Icon(
            //         FluentIcons.heart_24_filled,
            //         color: Colors.white,
            //       ),
            //       title: Text(
            //         context.l10n!.sponsorProject,
            //         style: const TextStyle(
            //           fontWeight: FontWeight.w600,
            //           color: Colors.white,
            //         ),
            //       ),
            //       onTap: () => {
            //         launchURL(
            //           Uri.parse('https://ko-fi.com/gokadzev'),
            //         ),
            //       },
            //     ),
            //   ),
            // ),
            // // CATEGORY: OTHERS
            // _buildSectionTitle(
            //   primaryColor,
            //   context.l10n!.others,
            // ),

            SettingBar(
              context.l10n!.licenses,
              FluentIcons.document_24_filled,
              () => NavigationManager.router.go(
                '/more/license',
              ),
            ),
            SettingBar(
              '${context.l10n!.copyLogs} (${logger.getLogCount()})',
              FluentIcons.error_circle_24_filled,
              () async => showToast(context, await logger.copyLogs(context)),
            ),
            SettingBar(
              context.l10n!.about,
              FluentIcons.book_information_24_filled,
              () => NavigationManager.router.go(
                '/more/about',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(Color primaryColor, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
