import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/glass_panel.dart';
import '../../../core/ui/glossy_button.dart';

/// Adult check before any coin or gem price list. Nothing is billed.
abstract final class ParentalGate {
  static const left = 8;
  static const right = 5;
  static int get answer => left + right;
}

Future<bool> showParentalGate(BuildContext context) async {
  final passed = await showDialog<bool>(
    context: context,
    builder: (context) => const _ParentalGateDialog(),
  );
  return passed ?? false;
}

class _ParentalGateDialog extends StatefulWidget {
  const _ParentalGateDialog();

  @override
  State<_ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<_ParentalGateDialog> {
  final _answer = TextEditingController();
  var _wrong = false;

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  void _submit() {
    final typed = int.tryParse(_answer.text.trim());
    if (typed == ParentalGate.answer) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _wrong = true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassPanel(
        key: const Key('parental_gate'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Grown-up check',
              style: TextStyle(
                fontFamily: AppTheme.displayFamily,
                fontSize: 24,
                color: GameColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text('What is ${ParentalGate.left} + ${ParentalGate.right}?'),
            const SizedBox(height: 8),
            TextField(
              key: const Key('parental_answer'),
              controller: _answer,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'Answer'),
            ),
            if (_wrong)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Try again', key: Key('parental_wrong')),
              ),
            const SizedBox(height: 12),
            GlossyButton(
              key: const Key('parental_ok'),
              label: 'OK',
              expand: true,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
