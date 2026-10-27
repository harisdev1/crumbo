import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/card_definition.dart';

class CardFlipReveal extends StatefulWidget {
  const CardFlipReveal({
    super.key,
    required this.card,
    required this.isNew,
    this.duplicateCoins = 0,
    this.reduceMotion = false,
    this.onFlipComplete,
  });

  final CardDefinition card;
  final bool isNew;
  final int duplicateCoins;
  final bool reduceMotion;
  final VoidCallback? onFlipComplete;

  @override
  State<CardFlipReveal> createState() => _CardFlipRevealState();
}

class _CardFlipRevealState extends State<CardFlipReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 500),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFlipComplete?.call();
      }
    });
    if (widget.reduceMotion) {
      _controller.value = 1;
      widget.onFlipComplete?.call();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final angle = t * math.pi;
        final showBack = t >= 0.5;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isNew)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'NEW!',
                  key: Key('card_reveal_new'),
                  style: TextStyle(
                    fontFamily: AppTheme.displayFamily,
                    fontSize: 28,
                    color: GameColors.coin,
                  ),
                ),
              )
            else if (widget.duplicateCoins > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Duplicate +${widget.duplicateCoins} coins',
                  key: const Key('card_reveal_duplicate'),
                  style: const TextStyle(
                    fontFamily: AppTheme.displayFamily,
                    fontSize: 20,
                    color: GameColors.purple,
                  ),
                ),
              ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: showBack
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _Face(
                        key: const Key('card_flip_back'),
                        child: _CardFront(card: widget.card),
                      ),
                    )
                  : _Face(
                      key: const Key('card_flip_front'),
                      child: const _CardBack(),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _Face extends StatelessWidget {
  const _Face({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 180, height: 240, child: child);
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [GameColors.purple, GameColors.purpleDeep],
        ),
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            fontFamily: AppTheme.displayFamily,
            fontSize: 64,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({required this.card});

  final CardDefinition card;

  Color get _rarityColor => switch (card.rarity) {
        CardRarity.common => GameColors.green,
        CardRarity.rare => GameColors.purple,
        CardRarity.superRare => GameColors.pink,
        CardRarity.golden => GameColors.coin,
      };

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _rarityColor, width: 4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 20,
                color: GameColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              card.rarity.name,
              style: TextStyle(color: _rarityColor),
            ),
          ],
        ),
      ),
    );
  }
}
