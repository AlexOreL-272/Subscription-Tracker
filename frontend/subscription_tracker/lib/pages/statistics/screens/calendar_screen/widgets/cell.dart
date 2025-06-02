import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  final DateTime date;

  const Cell({required this.date, super.key});

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    final padding =
        MediaQuery.of(context).padding.left +
        MediaQuery.of(context).padding.right;

    final width = (MediaQuery.of(context).size.width - padding) / 14;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: width, maxWidth: width),

      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),

        child: Center(
          child: Text(
            '${widget.date.day}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
