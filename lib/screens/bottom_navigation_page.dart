import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/extension/l10n.dart';
import 'package:music_app/main.dart';
import 'package:music_app/services/settings_manager.dart';
import 'package:music_app/widgets/mini_player.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;
  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  final _selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<MediaItem?>(
                stream: audioHandler.mediaItem,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    logger.log(
                      'Error in mini Player bar',
                      snapshot.error,
                      snapshot.stackTrace,
                    );
                  }
                  final metadata = snapshot.data;
                  if (metadata == null) {
                    return const SizedBox.shrink();
                  } else {
                    return MiniPlayer(metadata: metadata);
                  }
                }),
            NavigationBar(
                selectedIndex: _selectedIndex.value,
                labelBehavior: languageSetting == const Locale('en', '')
                    ? NavigationDestinationLabelBehavior.alwaysShow
                    : NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (index) {
                  widget.child.goBranch(index,
                      initialLocation: index == widget.child.currentIndex);
                  setState(() {
                    _selectedIndex.value = index;
                  });
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(FluentIcons.home_24_regular),
                    label: context.l10n?.home ?? 'Home',
                    selectedIcon: const Icon(
                      FluentIcons.home_24_filled,
                    ),
                  ),
                  NavigationDestination(
                    icon: const Icon(FluentIcons.search_24_regular),
                    label: context.l10n?.search ?? 'Search',
                    selectedIcon: const Icon(
                      FluentIcons.search_24_filled,
                    ),
                  ),
                  NavigationDestination(
                    icon: const Icon(FluentIcons.album_20_regular),
                    label: context.l10n?.userPlaylists ?? 'User Playlists',
                    selectedIcon: const Icon(
                      FluentIcons.album_24_filled,
                    ),
                  ),
                  NavigationDestination(
                    icon: const Icon(FluentIcons.settings_24_regular),
                    label: context.l10n?.more ?? 'More',
                    selectedIcon: const Icon(
                      FluentIcons.settings_24_filled,
                    ),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
