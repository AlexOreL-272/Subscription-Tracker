import 'package:flutter/material.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class UIColorPicker extends StatefulWidget {
  final Color color;
  final BoxDecoration? decoration;
  final ValueChanged<Color> onChanged;

  final double buttonSize;
  final Size pickerSize;

  static final _colorSchemes = <ColorScheme>[
    ...UIColorSeed.values.map((e) => ColorScheme.fromSeed(seedColor: e.color)),
  ];

  const UIColorPicker({
    super.key,
    required this.color,
    this.decoration,
    required this.onChanged,

    this.buttonSize = 24.0,
    this.pickerSize = const Size(double.infinity, 42.0),
  });

  @override
  State<UIColorPicker> createState() => _UIColorPickerState();
}

class _UIColorPickerState extends State<UIColorPicker> {
  late Color _selectedColor = widget.color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final uiColor = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    return SizedBox(
      width: widget.pickerSize.width,
      height: widget.pickerSize.height,

      child: DecoratedBox(
        decoration: BoxDecoration(
          color: uiColor.container,
          border: Border.all(color: uiColor.border),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: uiColor.shadow,
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ),
          ],
        ),

        child: Center(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),

            itemCount: UIColorSeed.values.length,

            itemBuilder: (context, index) {
              return _buildColorPickerItem(
                index,
                size: widget.pickerSize.height * 0.8,
                isChecked: _selectedColor == UIColorSeed.values[index].color,
              );
            },

            separatorBuilder: (context, index) {
              return const SizedBox(width: 8.0);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildColorPickerItem(
    int index, {
    double size = 24.0,
    bool isChecked = false,
  }) {
    final mainColor = UIColorPicker._colorSchemes[index].primaryContainer;
    final contrastColor = UIColorPicker._colorSchemes[index].primaryFixedDim;

    final brightness = ThemeData.estimateBrightnessForColor(mainColor);
    final iconColor =
        brightness == Brightness.light ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        _selectedColor = UIColorSeed.values[index].color;
        widget.onChanged(_selectedColor);
      },

      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: contrastColor, width: 2.0),
            shape: BoxShape.circle,
          ),

          child: Center(
            child: Stack(
              alignment: Alignment.center,

              children: [
                CircleAvatar(
                  backgroundColor: mainColor,
                  radius: size / 2.0 - 2.0,
                ),

                if (isChecked) ...{
                  Icon(Icons.check, color: iconColor, size: size / 2),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
