import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../economy/presentation/cubit/economy_cubit.dart';
import '../domain/card_definition.dart';
import 'card_reveal_page.dart';
import 'cubit/cards_cubit.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key, this.economy, this.cards});

  /// Injected for tests (already hydrated).
  final EconomyCubit? economy;
  final CardsCubit? cards;

  @override
  Widget build(BuildContext context) {
    if (economy != null && cards != null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: economy!),
          BlocProvider.value(value: cards!),
        ],
        child: const _AlbumView(),
      );
    }
    return BlocProvider(
      create: (_) => EconomyCubit()..hydrate(),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (ctx) => CardsCubit(economy: ctx.read<EconomyCubit>())
              ..hydrate(),
            child: const _AlbumView(),
          );
        },
      ),
    );
  }
}

class _AlbumView extends StatelessWidget {
  const _AlbumView();

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('album_page'),
      title: 'Album',
      body: BlocBuilder<CardsCubit, CardsUiState>(
        builder: (context, state) {
          if (!state.ready) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  key: const Key('album_progress'),
                  '${state.ownedDistinct}/${state.cards.length}',
                  style: const TextStyle(
                    fontFamily: AppTheme.displayFamily,
                    fontSize: 22,
                    color: GameColors.ink,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.cards.length,
                  itemBuilder: (context, index) {
                    final card = state.cards[index];
                    final owned = state.isOwned(card.id);
                    return _AlbumTile(
                      card: card,
                      owned: owned,
                      onTap: () => _onTap(context, card, owned),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    CardDefinition card,
    bool owned,
  ) async {
    if (owned) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CardRevealPage(
            card: card,
            isNew: false,
            duplicateCoins: 0,
          ),
        ),
      );
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return _UnlockSheet(card: card);
      },
    );
  }
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({
    required this.card,
    required this.owned,
    required this.onTap,
  });

  final CardDefinition card;
  final bool owned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: owned
          ? Key('album_card_${card.id}')
          : Key('album_locked_${card.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: owned ? Colors.white : const Color(0xFFE8E4F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: owned ? GameColors.purple : Colors.white,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            owned ? card.name : '?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.displayFamily,
              fontSize: owned ? 14 : 32,
              color: owned ? GameColors.ink : GameColors.purple.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnlockSheet extends StatelessWidget {
  const _UnlockSheet({required this.card});

  final CardDefinition card;

  @override
  Widget build(BuildContext context) {
    final cards = context.read<CardsCubit>();
    CardUnlock? coinsUnlock;
    CardUnlock? taskUnlock;
    for (final u in card.unlock) {
      if (u.method == UnlockMethod.coins) coinsUnlock = u;
      if (u.method == UnlockMethod.task) taskUnlock = u;
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            card.name,
            style: const TextStyle(
              fontFamily: AppTheme.displayFamily,
              fontSize: 22,
              color: GameColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          const Text('Keep playing to unlock!'),
          const SizedBox(height: 16),
          if (coinsUnlock?.price != null)
            GlossyButton(
              key: Key('album_unlock_coins_${card.id}'),
              label: 'Buy ${coinsUnlock!.price} coins',
              onPressed: () async {
                final result = await cards.unlockWithCoins(card.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not enough coins')),
                  );
                  return;
                }
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CardRevealPage(
                      card: result.card,
                      isNew: result.isNew,
                      duplicateCoins: result.duplicateCoins,
                    ),
                  ),
                );
              },
            ),
          if (taskUnlock?.need != null) ...[
            const SizedBox(height: 8),
            GlossyButton(
              key: Key('album_unlock_task_${card.id}'),
              label: 'Claim task',
              onPressed: () async {
                final result = await cards.unlockWithTask(card.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task not finished yet')),
                  );
                  return;
                }
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CardRevealPage(
                      card: result.card,
                      isNew: result.isNew,
                      duplicateCoins: result.duplicateCoins,
                    ),
                  ),
                );
              },
            ),
          ],
          if (cards.ad.isAvailable) ...[
            const SizedBox(height: 8),
            GlossyButton(
              key: Key('album_unlock_ad_${card.id}'),
              label: 'Watch ad',
              onPressed: null,
            ),
          ],
        ],
      ),
    );
  }
}
