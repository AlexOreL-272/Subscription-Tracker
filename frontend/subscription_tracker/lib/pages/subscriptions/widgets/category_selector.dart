import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/category_bloc/category_bloc.dart';
import 'package:subscription_tracker/models/category_bloc/category_event.dart';
import 'package:subscription_tracker/models/category_bloc/category_state.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_event.dart';
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
                state.categories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;

                  return Tab(child: Text(category));
                }).toList(),

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

class _EditDeleteOverlay extends StatefulWidget {
  final int index;
  final String category;
  final Widget child;

  const _EditDeleteOverlay({
    required this.index,
    required this.category,
    required this.child,
  });

  @override
  State<_EditDeleteOverlay> createState() => _EditDeleteOverlayState();
}

// TODO: rethink this
class _EditDeleteOverlayState extends State<_EditDeleteOverlay> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showDeleteDialog(BuildContext context, String category, int index) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить категорию'),
          content: Text(
            'Вы уверены, что хотите удалить категорию "$category"?',
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),

            TextButton(
              onPressed: () {
                context.read<CategoryBloc>().add(DeleteCategoryEvent(category));
                Navigator.pop(context);

                // If the deleted category was selected, move to the first tab
                if (widget.index == index) {
                  // widget.tabController.animateTo(0);
                  // widget.onChanged(
                  //   context.read<CategoryBloc>().state.categories[0],
                  // );
                }
              },

              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, String category, int index) {
    final TextEditingController controller = TextEditingController(
      text: category,
    );

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Переименовать'),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Введите новое название категории',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),

              child: const Text('Отмена'),
            ),

            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  BlocProvider.of<CategoryBloc>(
                    context,
                  ).add(RenameCategoryEvent(index, controller.text.trim()));

                  BlocProvider.of<SubscriptionBloc>(
                    context,
                  ).add(ResetCategoriesEvent(category, controller.text.trim()));

                  Navigator.pop(context);
                }
              },

              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _showOverlay() {
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: WasubiColors.wasubiNeutral[400]!),
      ),

      clipBehavior: Clip.hardEdge,

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          TextButton.icon(
            icon: const Icon(Icons.mode_edit_outline_outlined),

            label: const Text(
              'Переименовать',
              style: TextStyle(fontSize: 12.0),
            ),

            onPressed: () {
              Navigator.pop(context);
              _showRenameDialog(context, widget.category, widget.index);
            },
          ),

          const Divider(height: 1.0),

          TextButton.icon(
            icon: const Icon(Icons.delete),

            label: const Text('Delete Category'),

            onPressed: () {
              Navigator.pop(context);
              _showDeleteDialog(context, widget.category, widget.index);
            },
          ),
        ],
      ),
    );
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,

      child: GestureDetector(
        onLongPress: _showOverlay,
        behavior: HitTestBehavior.opaque,

        child: widget.child,
      ),
    );
  }
}
