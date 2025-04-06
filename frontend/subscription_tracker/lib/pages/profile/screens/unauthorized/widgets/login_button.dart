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

class FilledLoginButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const FilledLoginButton({
    required this.label,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,

      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,

        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        ),

        fixedSize: WidgetStateProperty.all(
          Size(MediaQuery.of(context).size.width, 44.0),
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
