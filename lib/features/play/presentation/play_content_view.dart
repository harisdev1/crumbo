import 'package:flutter/material.dart';

import '../domain/play_content.dart';

class PlayContentView extends StatelessWidget {
  const PlayContentView({super.key, required this.builder});

  final Widget Function(BuildContext context, PlayContent content) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlayContent>(
      future: PlayContent.load(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(child: Text('Could not load: ${snap.error}'));
        }
        final content = snap.data;
        if (content == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return builder(context, content);
      },
    );
  }
}
