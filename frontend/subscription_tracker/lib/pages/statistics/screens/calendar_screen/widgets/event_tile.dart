import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class EventTileData {
  final String caption;
  final double cost;
  final String currency;

  const EventTileData({
    required this.caption,
    required this.cost,
    required this.currency,
  });
}

class EventTile extends StatelessWidget {
  final EventTileData data;

  final TextStyle style;
  final BoxDecoration decoration;

  const EventTile({
    required this.data,
    this.style = const TextStyle(),
    this.decoration = const BoxDecoration(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration,

      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textPainter = TextPainter(
                    text: TextSpan(text: data.caption, style: style),
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                  )..layout(maxWidth: constraints.maxWidth);

                  final textOverflows = textPainter.didExceedMaxLines;

                  return SizedBox(
                    height: 40,

                    child:
                        textOverflows
                            ? Marquee(
                              text: data.caption,
                              style: style,

                              blankSpace: 100.0,
                              velocity: 50,

                              pauseAfterRound: const Duration(seconds: 1),
                            )
                            : Align(
                              alignment: Alignment.centerLeft,

                              child: Text(data.caption, style: style),
                            ),
                  );
                },
              ),
            ),

            const SizedBox(width: 8.0),

            Text(
              '${data.cost.toStringAsFixed(2)} ${data.currency}',
              style: Theme.of(context).textTheme.titleLarge,

              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
