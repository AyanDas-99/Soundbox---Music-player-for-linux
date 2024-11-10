import 'package:flutter/material.dart';
import 'package:soundbox/state/error_list.dart';
import 'package:soundbox/state/favourites/favourites.dart';
import 'package:path/path.dart' as p;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ErrorListScreen extends ConsumerStatefulWidget {
  const ErrorListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ErrorListScreenState();
}

class _ErrorListScreenState extends ConsumerState<ErrorListScreen> {
  @override
  Widget build(BuildContext context) {
    final errorList = ref.watch(errorListProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Import Errors',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (errorList.isEmpty)
            const Center(
              child: Text('No import errors'),
            ),
          if (errorList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: errorList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    textColor: Colors.white,
                    title: Text(p.basename(errorList[index])),
                    iconColor: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MusicListItemMenu extends ConsumerStatefulWidget {
  const MusicListItemMenu({
    super.key,
    required this.songPath,
  });

  final String songPath;

  @override
  ConsumerState<MusicListItemMenu> createState() => _MusicListItemMenuState();
}

class _MusicListItemMenuState extends ConsumerState<MusicListItemMenu> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.shade800),
      ),
      menuChildren: [
        ListTile(
          onTap: () async {
            final messenger = ScaffoldMessenger.of(context);
            final result = await ref
                .read(favouritesProvider.notifier)
                .addToFav(widget.songPath);
            if (result.success) {
              messenger.showSnackBar(
                  const SnackBar(content: Text('Added to favourite')));
            } else {
              messenger.showSnackBar(SnackBar(content: Text(result.msg!)));
            }
            _menuController.close();
          },
          title: const Text(
            'Add to favourites',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
      builder: (context, controller, child) => IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert)),
    );
  }
}
