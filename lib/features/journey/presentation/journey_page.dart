import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/game_page.dart';
import '../../../core/ui/glossy_button.dart';
import '../../cards/presentation/cubit/cards_cubit.dart';
import '../../economy/presentation/cubit/economy_cubit.dart';
import '../domain/journey_models.dart';
import 'cubit/journey_cubit.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key, this.economy, this.cards, this.journey});

  /// Injected for tests (already hydrated).
  final EconomyCubit? economy;
  final CardsCubit? cards;
  final JourneyCubit? journey;

  @override
  Widget build(BuildContext context) {
    if (economy != null && cards != null && journey != null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: economy!),
          BlocProvider.value(value: cards!),
          BlocProvider.value(value: journey!),
        ],
        child: const _JourneyView(),
      );
    }
    return BlocProvider(
      create: (_) => EconomyCubit()..hydrate(),
      child: Builder(
        builder: (context) {
          final eco = context.read<EconomyCubit>();
          return BlocProvider(
            create: (_) => CardsCubit(economy: eco)..hydrate(),
            child: Builder(
              builder: (context) {
                return BlocProvider(
                  create: (ctx) => JourneyCubit(
                    economy: eco,
                    cards: ctx.read<CardsCubit>(),
                  )..hydrate(),
                  child: const _JourneyView(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _JourneyView extends StatelessWidget {
  const _JourneyView();

  @override
  Widget build(BuildContext context) {
    return GamePage(
      pageKey: const Key('journey_page'),
      title: 'Journey',
      body: BlocBuilder<JourneyCubit, JourneyUiState>(
        builder: (context, state) {
          if (!state.ready) {
            return const Center(child: CircularProgressIndicator());
          }
          final journey = context.read<JourneyCubit>();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final zone in state.catalog.zones) ...[
                Text(
                  zone.name,
                  key: Key('journey_zone_${zone.id}'),
                  style: TextStyle(
                    fontFamily: AppTheme.displayFamily,
                    fontSize: 22,
                    color: journey.isZoneUnlocked(zone.id)
                        ? GameColors.ink
                        : GameColors.ink.withValues(alpha: 0.4),
                  ),
                ),
                if (!journey.isZoneUnlocked(zone.id))
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text('Locked — finish previous zone'),
                  )
                else
                  ...List.generate(zone.nodes.length, (index) {
                    final node = zone.nodes[index];
                    final done = journey.isNodeCompleted(node.id);
                    final current = journey.isCurrent(zone, index);
                    final locked = !journey.canAttempt(zone, index);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _NodeTile(
                        node: node,
                        done: done,
                        current: current,
                        locked: locked && !done,
                        onTap: () => _onNodeTap(context, node),
                      ),
                    );
                  }),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _onNodeTap(BuildContext context, JourneyNode node) async {
    final journey = context.read<JourneyCubit>();
    if (node.type == JourneyNodeType.gate) {
      await showModalBottomSheet<void>(
        context: context,
        builder: (_) => BlocProvider.value(
          value: journey,
          child: _GateSheet(node: node),
        ),
      );
      return;
    }
    final err = await journey.tryCompleteNode(node.id);
    if (!context.mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Node complete!')),
      );
    }
  }
}

class _NodeTile extends StatelessWidget {
  const _NodeTile({
    required this.node,
    required this.done,
    required this.current,
    required this.locked,
    required this.onTap,
  });

  final JourneyNode node;
  final bool done;
  final bool current;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = done
        ? GameColors.green
        : current
            ? GameColors.purple
            : Colors.white;
    return InkWell(
      key: Key('journey_node_${node.id}'),
      onTap: locked ? null : onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${node.id} · ${node.type.name}',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: (done || current) ? Colors.white : GameColors.ink,
                  ),
                ),
              ),
              if (locked)
                const Icon(Icons.lock_rounded, color: GameColors.ink)
              else if (done)
                const Icon(Icons.check_rounded, color: Colors.white)
              else
                const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _GateSheet extends StatelessWidget {
  const _GateSheet({required this.node});

  final JourneyNode node;

  @override
  Widget build(BuildContext context) {
    // Read cubit from parent (sheet is under same tree if we pass via builder carefully).
    final journey = context.read<JourneyCubit>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Gate ${node.id}',
            style: const TextStyle(
              fontFamily: AppTheme.displayFamily,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),
          for (final opt in node.gateOptions)
            if (opt.method == GateMethod.coins && opt.coinNeed != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlossyButton(
                  key: Key('gate_pay_coins_${node.id}'),
                  label: 'Pay ${opt.coinNeed} coins',
                  onPressed: () async {
                    final err = await journey.payGateCoins(node.id);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(err ?? 'Gate opened!'),
                      ),
                    );
                  },
                ),
              )
            else if (opt.method == GateMethod.task)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlossyButton(
                  key: Key('gate_task_${node.id}'),
                  label: 'Do task (coming soon)',
                  onPressed: null,
                ),
              )
            else if (opt.method == GateMethod.ad)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlossyButton(
                  key: Key('gate_ad_${node.id}'),
                  label: 'Watch ad (soon)',
                  onPressed: null,
                ),
              ),
        ],
      ),
    );
  }
}
