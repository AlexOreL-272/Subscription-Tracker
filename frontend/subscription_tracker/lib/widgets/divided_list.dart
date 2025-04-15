import 'package:flutter/material.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class DividedNamedList extends StatelessWidget {
  static final _divider = Divider(
    color: WasubiColors.wasubiNeutral[400]!,
    height: 1.0,
  );

  final List<NamedEntry> children;

  const DividedNamedList({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.brightness == Brightness.dark
                ? Color(0xFF282828)
                : Color.fromARGB(255, 248, 249, 250),

        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.brightness == Brightness.dark
                  ? Colors.white.withAlpha(20)
                  : Colors.grey[200]!,

          width: 1.0,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? Colors.white.withAlpha(10)
                    : Colors.black.withAlpha(10),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        // I tried using a ListView.separated, but it ruined the layout
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1) _divider,
            ],
          ],
        ),
      ),
    );
  }
}

class NamedEntry extends StatelessWidget {
  static const double height = 32.0;
  static const double contentHeight = 28.0;

  final String name;
  final Widget child;

  const NamedEntry({required this.name, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,

      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.grey[900],
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: contentHeight, child: child),
          ],
        ),
      ),
    );
  }
}

class ExpandableDividedNamedList extends StatefulWidget {
  final String label;
  final bool isActive;
  final ValueChanged<bool>? onSwitch;
  final List<NamedEntry> children;

  static final _divider = Divider(
    color: WasubiColors.wasubiNeutral[400]!,
    height: 1.0,
  );

  const ExpandableDividedNamedList({
    required this.label,
    this.isActive = false,
    this.onSwitch,
    required this.children,
    super.key,
  });

  @override
  State<ExpandableDividedNamedList> createState() =>
      _ExpandableDividedNamedListState();
}

class _ExpandableDividedNamedListState extends State<ExpandableDividedNamedList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool _isExpanded = widget.isActive;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (_isExpanded) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion(_) {
    FocusScope.of(context).unfocus();

    setState(() {
      _isExpanded = !_isExpanded;

      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    widget.onSwitch?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.brightness == Brightness.dark
                ? Color(0xFF282828)
                : Color.fromARGB(255, 248, 249, 250),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.brightness == Brightness.dark
                  ? Colors.white.withAlpha(20)
                  : Colors.grey[200]!,

          width: 1.0,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? Colors.white.withAlpha(10)
                    : Colors.black.withAlpha(10),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),

        child: Column(
          children: [
            NamedEntry(
              name: widget.label,

              child: Transform.scale(
                scale: 24.0 / 32.0,
                alignment: Alignment.centerRight,

                child: Switch(
                  value: _isExpanded,

                  onChanged: _toggleExpansion,

                  trackColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                  thumbColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Color(0xFF3F3F3F)
                        : Colors.white,
                  ),
                  trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),

                  padding: EdgeInsets.zero,
                ),
              ),
            ),

            if (_isExpanded || _controller.value > 0) ...[
              for (int i = 0; i < widget.children.length; i++) ...[
                _SlideInItem(
                  controller: _controller,
                  delay: i / widget.children.length,

                  child: Column(
                    children: [
                      ExpandableDividedNamedList._divider,
                      widget.children[i],
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SlideInItem extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _SlideInItem({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      curve: Interval(0.0, 1.0, curve: Curves.easeIn),
      parent: controller,
    );

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: -1.0,
      child: child,
    );
  }
}
