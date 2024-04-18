import 'package:flutter/material.dart';

class SettingBar extends StatelessWidget {
  SettingBar(this.tileName, this.tileIcon, this.onTap, {super.key});

  final VoidCallback onTap;
  final String tileName;
  final IconData tileIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: ListTile(
          autofocus: true,
          leading: Icon(tileIcon),
          title: Text(
            tileName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
