import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/glass_panel.dart';
import '../../../../core/ui/glossy_button.dart';

Future<void> showExitDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: GlassPanel(
          key: const Key('exit_dialog'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Leave Owl?',
                style: TextStyle(
                  fontFamily: AppTheme.displayFamily,
                  fontSize: 28,
                  color: GameColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text('See you soon!'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GlossyButton(
                      key: const Key('exit_no'),
                      label: 'No',
                      color: GameColors.green,
                      expand: true,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlossyButton(
                      key: const Key('exit_yes'),
                      label: 'Yes',
                      color: GameColors.coral,
                      expand: true,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        SystemNavigator.pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
