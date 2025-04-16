import 'package:flutter/material.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class ColorPicker extends StatefulWidget {
  final Color color;
  final BoxDecoration? decoration;
  final ValueChanged<Color> onChanged;

  final double buttonSize;
  final Size pickerSize;

  static final _colorSchemes = <ColorScheme>[
    ...ColorSeed.values.map((e) => ColorScheme.fromSeed(seedColor: e.color)),
  ];

  const ColorPicker({
    super.key,
    required this.color,
    this.decoration,
    required this.onChanged,

    this.buttonSize = 24.0,
    this.pickerSize = const Size(300.0, 42.0),
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  late Color _selectedColor = widget.color;
  bool _isPickerOpen = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isPickerOpen = false;
  }

  void _togglePicker() {
    if (_isPickerOpen) {
      _removeOverlay();
    } else {
      _showPicker();
    }
  }

  void _showPicker() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _removeOverlay,

          child: Stack(
            children: [
              Positioned(
                height: widget.pickerSize.height,
                width: widget.pickerSize.width,

                child: CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: Alignment.topRight,
                  followerAnchor: Alignment.bottomRight,

                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          widget.decoration?.borderRadius ??
                          BorderRadius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,

                    child: Container(
                      decoration: widget.decoration,
                      clipBehavior: Clip.hardEdge,

                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),

                        itemCount: ColorSeed.values.length,

                        itemBuilder: (context, index) {
                          return _buildColorPickerItem(
                            index,
                            size: widget.pickerSize.height * 0.8,
                            isChecked:
                                _selectedColor.toARGB32() ==
                                ColorSeed.values[index].color.toARGB32(),
                          );
                        },

                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 8.0);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isPickerOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: widget.color);

    return CompositedTransformTarget(
      link: _layerLink,

      child: GestureDetector(
        onTap: () {
          _togglePicker();
        },

        child: SizedBox(
          width: widget.buttonSize,
          height: widget.buttonSize,

          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorScheme.primaryFixedDim),
              shape: BoxShape.circle,
            ),

            child: Center(
              child: Stack(
                alignment: Alignment.center,

                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    radius: widget.buttonSize / 2.0 - 2.0,
                  ),
                ],
              ),
            ),
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
    final mainColor = ColorPicker._colorSchemes[index].primaryContainer;
    final contrastColor = ColorPicker._colorSchemes[index].primaryFixedDim;

    final brightness = ThemeData.estimateBrightnessForColor(mainColor);
    final iconColor =
        brightness == Brightness.light ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        _selectedColor = ColorSeed.values[index].color;
        widget.onChanged(_selectedColor);
        _removeOverlay();
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
