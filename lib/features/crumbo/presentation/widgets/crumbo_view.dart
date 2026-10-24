import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;

import '../../domain/owl_expression.dart';
import '../cubit/crumbo_cubit.dart';

/// Loads owl Rive files and switches expression artboards from [CrumboCubit].
///
/// Classic skin: `assets/rive/owl.riv` + `owl_sleep.riv`. Other skins load the
/// recolored copies from `assets/rive/skins/` with the same artboards.
class CrumboView extends StatelessWidget {
  const CrumboView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrumboCubit, CrumboCharacterState>(
      buildWhen: (prev, next) =>
          prev.expression != next.expression ||
          prev.activeSkinId != next.activeSkinId,
      builder: (context, state) {
        final expression = state.expression;
        final assetPath =
            context.read<CrumboCubit>().activeSkin.riveAssetFor(expression);
        return _OwlArtboardPlayer(
          key: ValueKey<String>('$assetPath:${expression.artboardName}'),
          assetPath: assetPath,
          artboardName: expression.artboardName,
          stageScale: expression.stageScale,
          breathe: expression == OwlExpression.sleep,
          onTap: () => context.read<CrumboCubit>().onCharacterTapped(),
        );
      },
    );
  }
}

class _OwlArtboardPlayer extends StatefulWidget {
  const _OwlArtboardPlayer({
    super.key,
    required this.assetPath,
    required this.artboardName,
    required this.stageScale,
    required this.breathe,
    required this.onTap,
  });

  final String assetPath;
  final String artboardName;
  final double stageScale;
  final bool breathe;
  final VoidCallback onTap;

  @override
  State<_OwlArtboardPlayer> createState() => _OwlArtboardPlayerState();
}

class _OwlArtboardPlayerState extends State<_OwlArtboardPlayer>
    with SingleTickerProviderStateMixin {
  late final rive.FileLoader _fileLoader = rive.FileLoader.fromAsset(
    widget.assetPath,
    riveFactory: rive.Factory.rive,
  );

  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.breathe) {
      _breath.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _OwlArtboardPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.breathe && !_breath.isAnimating) {
      _breath.repeat(reverse: true);
    } else if (!widget.breathe && _breath.isAnimating) {
      _breath.stop();
      _breath.value = 0;
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return rive.RiveWidgetBuilder(
      fileLoader: _fileLoader,
      artboardSelector: rive.ArtboardSelector.byName(widget.artboardName),
      stateMachineSelector: rive.StateMachineSelector.byDefault(),
      builder: (context, state) {
        return switch (state) {
          rive.RiveLoading() => const Center(
              child: CircularProgressIndicator(
                key: Key('crumbo_rive_loading'),
              ),
            ),
          rive.RiveFailed(:final error) => Center(
              child: Text(
                'Owl failed to load: $error',
                key: const Key('crumbo_rive_failed'),
                textAlign: TextAlign.center,
              ),
            ),
          rive.RiveLoaded(:final controller) => GestureDetector(
              key: const Key('crumbo_rive'),
              onTap: widget.onTap,
              child: AnimatedBuilder(
                animation: _breath,
                builder: (context, child) {
                  final t = widget.breathe ? _breath.value : 0.0;
                  final breathScale = 1 + 0.055 * t;
                  final dy = widget.breathe ? -6.0 * t : 0.0;
                  return Transform.translate(
                    offset: Offset(0, dy),
                    child: AnimatedScale(
                      scale: widget.stageScale,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      child: Transform.scale(
                        scale: breathScale,
                        child: child,
                      ),
                    ),
                  );
                },
                child: rive.RiveWidget(
                  controller: controller,
                  fit: rive.Fit.contain,
                ),
              ),
            ),
        };
      },
      onFailed: (error, stackTrace) {
        debugPrint('Owl Rive load failed: $error\n$stackTrace');
      },
    );
  }
}
