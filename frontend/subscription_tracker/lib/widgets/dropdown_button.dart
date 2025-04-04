import 'dart:math';

import 'package:flutter/material.dart';
import 'package:subscription_tracker/screens/subscriptions/common/scripts/scripts.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class Dropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;

  final ValueChanged<T?>? onChanged;

  final Widget? hint;
  final Widget? icon;

  final double dropdownWidth;
  final TextStyle? buttonTextStyle;
  final TextStyle? dropdownTextStyle;
  final BoxDecoration? buttonDecoration;
  final BoxDecoration? dropdownDecoration;

  final EdgeInsetsGeometry? padding;

  final bool showSelectedItem;

  const Dropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.icon,
    this.dropdownWidth = 0,
    this.buttonTextStyle,
    this.dropdownTextStyle,
    this.buttonDecoration,
    this.dropdownDecoration,
    this.padding,
    this.showSelectedItem = true,
  });

  @override
  DropdownState<T> createState() => DropdownState<T>();
}

class DropdownState<T> extends State<Dropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  late final double dropdownWidth =
      widget.dropdownWidth == 0
          ? widget.items
                  .map(
                    (elem) =>
                        getTextWidth(elem.toString(), widget.dropdownTextStyle),
                  )
                  .reduce((a, b) => max(a, b)) +
              24.0
          : widget.dropdownWidth;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showDropdown();
    }
  }

  Widget _buildDropdownItem(T item) {
    final isSelected = item == widget.value;

    return Container(
      decoration:
          isSelected
              ? BoxDecoration(
                color:
                    widget.buttonDecoration?.color ??
                    WasubiColors.wasubiPurple[150]!,
              )
              : null,

      height: 32.0,

      alignment: Alignment.centerLeft,

      padding: const EdgeInsets.symmetric(horizontal: 8.0),

      child: Text(
        item.toString(),
        style:
            widget.dropdownTextStyle ??
            TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
      ),
    );
  }

  void _showDropdown() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _removeOverlay,

          child: Stack(
            children: [
              Positioned(
                width: dropdownWidth,

                child: CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: Alignment.bottomRight,
                  followerAnchor: Alignment.topRight,
                  showWhenUnlinked: false,

                  child: Material(
                    child: Container(
                      decoration: widget.dropdownDecoration,
                      clipBehavior: Clip.hardEdge,
                      constraints: BoxConstraints(maxHeight: 300.0),

                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,

                            onTap: () {
                              widget.onChanged?.call(widget.items[index]);
                              _removeOverlay();
                            },

                            child: _buildDropdownItem(widget.items[index]),
                          );
                        },

                        separatorBuilder: (context, index) {
                          return const Divider(height: 1.0);
                        },

                        itemCount: widget.items.length,

                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
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
    _isDropdownOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.firstWhere(
      (item) => item == widget.value,
      orElse: () => widget.items.first,
    );

    return CompositedTransformTarget(
      link: _layerLink,

      child: GestureDetector(
        onTap: _toggleDropdown,

        child: Container(
          padding: widget.padding ?? EdgeInsets.only(left: 8.0),

          decoration: widget.buttonDecoration,

          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Flexible(
                child: Text(
                  selectedItem.toString(),
                  style:
                      widget.buttonTextStyle ??
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
              ),

              if (widget.icon != null) widget.icon!,
            ],
          ),
        ),
      ),
    );
  }
}
