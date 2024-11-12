import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:soundbox/state/stream/stream.dart';

class StreamScreen extends ConsumerStatefulWidget {
  const StreamScreen({super.key});

  @override
  ConsumerState<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends ConsumerState<StreamScreen> {
  final _urlController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Play From URL",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  hintText: 'https://path-to-music/music.mp3',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                ),
                style: TextStyle(color: Colors.grey.shade100),
              )),
              const SizedBox(width: 10),
              TextButton(
                style: ButtonStyle(
                    shape: const WidgetStatePropertyAll(StadiumBorder()),
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.grey.shade800),
                    padding: const WidgetStatePropertyAll(EdgeInsets.all(20))),
                onPressed: loading
                    ? null
                    : () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        if (_urlController.text.isEmpty) {
                          return;
                        }
                        setState(() {
                          loading = true;
                        });
                        final result = await ref
                            .read(streamProvider.notifier)
                            .play(_urlController.text);
                        if (!result.success) {
                          scaffoldMessenger.showSnackBar(SnackBar(
                              content:
                                  Text(result.error ?? 'Error playing audio')));
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (loading) const CircularProgressIndicator(),
                    if (!loading)
                      const Icon(
                        Icons.play_arrow_outlined,
                        color: Colors.orange,
                      ),
                    const SizedBox(width: 10),
                    const Text(
                      'Play',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
