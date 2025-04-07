import 'package:flutter/material.dart';

class OutlinedLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const OutlinedLoginButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(icon),

      label: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
      ),

      onPressed: onPressed,

      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,

        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        ),

        side: WidgetStateProperty.all(BorderSide(color: color, width: 2.0)),

        fixedSize: WidgetStateProperty.all(
          Size(MediaQuery.of(context).size.width, 44.0),
        ),

        iconSize: WidgetStateProperty.all(20.0),
        iconColor: WidgetStateProperty.all(color),
      ),
    );
  }
}

class FilledButton extends StatelessWidget {
  final String label;
  final Color color;

  final double? width;
  final double height;

  final VoidCallback onPressed;

  final Key? formKey;

  const FilledButton({
    required this.label,
    required this.color,

    this.width,
    required this.height,

    required this.onPressed,
    this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (formKey == null ||
            (formKey as GlobalKey<FormState>).currentState!.validate()) {
          onPressed();
        }
      },

      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,

        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        ),

        fixedSize: WidgetStateProperty.all(
          Size(width ?? MediaQuery.of(context).size.width, height),
        ),

        backgroundColor: WidgetStateProperty.all(color),
      ),

      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}
