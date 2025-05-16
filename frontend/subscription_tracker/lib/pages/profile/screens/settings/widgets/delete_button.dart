import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,

      label: Text(
        AppLocalizations.of(context)!.deleteDialogOption,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.red),
      ),

      icon: Icon(Icons.delete, color: Colors.red),

      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(Colors.red[100]!),

        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 4.0),
        ),

        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        ),
      ),
    );
  }
}
