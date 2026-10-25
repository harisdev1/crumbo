import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../crumbo/domain/owl_skin.dart';
import 'coloring_page.dart';

class MyOwlsPage extends StatelessWidget {
  const MyOwlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('my_owls_page'),
      title: 'My Owls',
      body: FutureBuilder<OwlSkinCatalog>(
        future: OwlSkinCatalog.load(),
        builder: (context, snap) {
          final skins = snap.data?.skins;
          if (skins == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            key: const Key('my_owls_grid'),
            padding: const EdgeInsets.all(16),
            itemCount: skins.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final skin = skins[index];
              return GestureDetector(
                key: Key('owl_card_${skin.id}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => OwlDetailPage(skin: skin),
                    ),
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: skin.cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(backgroundColor: skin.body, radius: 22),
                      const SizedBox(height: 6),
                      Text(
                        skin.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OwlDetailPage extends StatelessWidget {
  const OwlDetailPage({super.key, required this.skin});

  final OwlSkin skin;

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('owl_detail'),
      title: skin.name,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(backgroundColor: skin.body, radius: 64),
            const Spacer(),
            GlossyButton(
              key: const Key('owl_edit'),
              label: 'Edit',
              expand: true,
              onPressed: () => _soon(context),
            ),
            const SizedBox(height: 8),
            GlossyButton(
              key: const Key('owl_delete'),
              label: 'Delete',
              expand: true,
              color: GameColors.coral,
              onPressed: () => _soon(context),
            ),
            const SizedBox(height: 8),
            GlossyButton(
              key: const Key('open_coloring'),
              label: 'Color',
              expand: true,
              color: GameColors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ColoringPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
