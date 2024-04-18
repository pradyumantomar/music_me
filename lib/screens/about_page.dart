import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:music_app/api/version.dart';
import 'package:music_app/extension/l10n.dart';
import 'package:music_app/utils/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n!.about,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 17, 8, 0),
              child: Text(
                'MusicMe  | $appVersion',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(
              color: Colors.white24,
              thickness: 0.8,
              height: 50,
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        'https://avatars.githubusercontent.com/u/76039454?v=4',
                      ),
                    ),
                  ),
                ),
                title: const Text(
                  'Pradyuman Tomar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('WEB & APP Developer'),
                trailing: Wrap(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(FluentIcons.code_24_filled),
                      tooltip: 'Github',
                      onPressed: () {
                        launchURL(
                          Uri.parse('https://github.com/pradyumantomar'),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(FluentIcons.globe_24_filled),
                      tooltip: 'Website',
                      onPressed: () {
                        launchURL(
                          Uri.parse('https://google.com'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
