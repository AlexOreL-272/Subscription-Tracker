import 'package:flutter/material.dart';

class TextToggleSwitch extends StatefulWidget {
  final int initialIndex;
  final List<String> options;
  final ValueChanged<int> onChanged;
  final double width;
  final double height;
  final Color inactiveColor;
  final Color indicatorColor;
  final TextStyle activeTextStyle;
  final TextStyle inactiveTextStyle;

  const TextToggleSwitch({
    super.key,
    this.initialIndex = 0,
    required this.options,
    required this.onChanged,
    this.width = 200.0,
    this.height = 40.0,
    required this.inactiveColor,
    required this.indicatorColor,
    this.activeTextStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    this.inactiveTextStyle = const TextStyle(color: Colors.black87),
  });

  @override
  _TextToggleSwitchState createState() => _TextToggleSwitchState();
}

class _TextToggleSwitchState extends State<TextToggleSwitch>
    with SingleTickerProviderStateMixin {
  static const _spacing = 2.0;

  late int _selectedIndex = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final itemWidth = widget.width / widget.options.length - 2 * _spacing;

    return Container(
      width: widget.width,
      height: widget.height,

      decoration: BoxDecoration(
        color: widget.inactiveColor.withAlpha(50),
        borderRadius: BorderRadius.circular(8.0),
      ),

      child: Stack(
        alignment: Alignment.center,

        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),

            left: (itemWidth + 2 * _spacing) * _selectedIndex + _spacing,
            height: widget.height - 2 * _spacing,
            width: itemWidth,

            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.indicatorColor,
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),

          Row(
            children: List.generate(widget.options.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (index != _selectedIndex) {
                      setState(() {
                        _selectedIndex = index;
                      });

                      widget.onChanged(index);
                    }
                  },

                  child: Align(
                    alignment: Alignment.center,

                    child: Text(
                      widget.options[index],
                      style:
                          _selectedIndex == index
                              ? widget.activeTextStyle
                              : widget.inactiveTextStyle,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
