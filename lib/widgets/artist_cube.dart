import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ArtistCube extends StatelessWidget {
  const ArtistCube(
    this.artist, {
    super.key,
    this.borderRadius = 28,
    this.borderRadiusInner = 2,
    this.iconSize = 30,
  });

  final String artist;
  final double borderRadius;
  final double borderRadiusInner;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final calculatedSize = MediaQuery.of(context).size.height * 0.1;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: calculatedSize * 1.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: colorScheme.secondary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            FluentIcons.mic_sparkle_24_regular,
            size: iconSize,
            color: colorScheme.onPrimary,
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              artist,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
