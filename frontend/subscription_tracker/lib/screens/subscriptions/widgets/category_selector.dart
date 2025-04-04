import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/category_bloc/category_bloc.dart';
import 'package:subscription_tracker/models/category_bloc/category_state.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class CategorySelector extends StatefulWidget {
  final selectedIndex;

  final TabController tabController;

  final void Function(String) onChanged;

  const CategorySelector({
    required this.tabController,
    required this.onChanged,
    this.selectedIndex = 0,
    super.key,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (blocCtx, state) {
        return SizedBox(
          height: 30.0,

          child: TabBar(
            controller: widget.tabController,
            tabs:
                state.categories
                    .map((category) => Tab(text: category))
                    .toList(),

            labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),

            onTap: (index) {
              widget.onChanged(state.categories[widget.tabController.index]);
            },

            tabAlignment: TabAlignment.start,

            labelColor: WasubiColors.wasubiPurple,
            unselectedLabelColor: WasubiColors.wasubiNeutral[500],
            dividerColor: Colors.transparent,

            indicator: OverlineTabIndicator(color: WasubiColors.wasubiPurple),
            indicatorSize: TabBarIndicatorSize.tab,

            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),

            isScrollable: true,

            splashFactory: NoSplash.splashFactory,
            splashBorderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
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
