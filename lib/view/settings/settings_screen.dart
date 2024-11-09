import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:soundbox/state/music_directory.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      const Text(
                        'Music Directory',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueGrey.shade800,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            ref.watch(musicDirectoryProvider).value?.path ??
                                'Path',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  tileColor: Colors.white,
                  selectedTileColor: Colors.white,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            shape:
                                const WidgetStatePropertyAll(StadiumBorder()),
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.grey.shade800),
                            padding: const WidgetStatePropertyAll(
                                EdgeInsets.all(20))),
                        onPressed: () async {
                          final path = await FilePickerLinux().getDirectoryPath();
                          print(path);
                          if (path != null) {
                            ref
                                .read(musicDirectoryProvider.notifier)
                                .setMusicDirectory(path);
                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Browser',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
