import 'package:flutter/material.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class TabSelector extends StatefulWidget {
  final selectedIndex;

  final TabController tabController;
  final List<Widget> labels;

  final void Function(int) onChanged;

  const TabSelector({
    required this.tabController,
    required this.labels,
    required this.onChanged,
    this.selectedIndex = 0,
    super.key,
  });

  @override
  State<TabSelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<TabSelector> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0,

      child: TabBar(
        controller: widget.tabController,

        tabs: widget.labels,

        labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),

        onTap: (index) {
          widget.onChanged(widget.tabController.index);
        },

        tabAlignment: TabAlignment.start,

        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: WasubiColors.wasubiNeutral[500],
        dividerColor: Colors.transparent,

        indicator: OverlineTabIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
        indicatorSize: TabBarIndicatorSize.tab,

        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),

        isScrollable: true,

        splashFactory: NoSplash.splashFactory,
        splashBorderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

class OverlineTabIndicator extends Decoration {
  final BoxPainter _painter;

  OverlineTabIndicator({required Color color, double width = 4.0})
    : _painter = _OverlineTabIndicatorPainter(color, width);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _OverlineTabIndicatorPainter extends BoxPainter {
  final Paint _paint;
  final double width;

  _OverlineTabIndicatorPainter(Color color, this.width)
    : _paint =
          Paint()
            ..color = color
            ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final RRect rect = RRect.fromRectAndCorners(
      offset & Size(cfg.size?.width ?? 0, width),
      bottomLeft: Radius.circular(2.0),
      bottomRight: Radius.circular(2.0),
    );

    canvas.drawRRect(rect, _paint);
  }
}
