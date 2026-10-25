import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum CurrencyKind { coin, gem }

class CurrencyPill extends StatelessWidget {
  const CurrencyPill({
    super.key,
    required this.kind,
    required this.amount,
  });

  final CurrencyKind kind;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final coin = kind == CurrencyKind.coin;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: GameColors.ink.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Mark(coin: coin),
            const SizedBox(width: 6),
            Text(
              '$amount',
              style: const TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 16,
                color: GameColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mark extends StatelessWidget {
  const _Mark({required this.coin});

  final bool coin;

  @override
  Widget build(BuildContext context) {
    if (coin) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE082), GameColors.coin, Color(0xFFF9A825)],
          ),
          border: Border.all(color: const Color(0xFFFFF8E1), width: 2),
        ),
        child: const Icon(Icons.star_rounded, size: 14, color: Colors.white),
      );
    }
    return Transform.rotate(
      angle: 0.78,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          gradient: const LinearGradient(
            colors: [Color(0xFFE1BEE7), GameColors.gem, GameColors.purpleDeep],
          ),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}
