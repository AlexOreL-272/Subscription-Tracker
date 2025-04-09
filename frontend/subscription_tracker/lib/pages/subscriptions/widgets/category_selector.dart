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

                  return _EditDeleteOverlay(
                    index: index,
                    category: category,
                    child: Tab(child: Text(category)),
                  );
                }).toList(),

            labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),

            onTap: (index) {
              widget.onChanged(state.categories[widget.tabController.index]);
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
  void _showDeleteDialog(BuildContext context, String category, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return _DeleteDialog(category: category, index: index);
      },
    );
  }

  void _showRenameDialog(BuildContext context, String category, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return _EditDialog(category: category, index: index);
      },
    );
  }

  void _showOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: false,

      builder: (context) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: WasubiColors.wasubiNeutral[400]!),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              TextButton.icon(
                icon: const Icon(
                  Icons.mode_edit_outline_outlined,
                  color: Colors.black,
                ),

                label: Text(
                  'Переименовать',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.black),
                ),

                onPressed: () {
                  Navigator.pop(context);
                  _showRenameDialog(context, widget.category, widget.index);
                },

                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(
                    WasubiColors.wasubiNeutral[400]!,
                  ),
                ),
              ),

              const Divider(height: 1.0),

              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),

                label: Text(
                  'Удалить',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.red),
                ),

                onPressed: () {
                  Navigator.pop(context);
                  _showDeleteDialog(context, widget.category, widget.index);
                },

                style: ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.red[100]!),
                ),
              ),

              const Divider(height: 1.0),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (widget.category.isEmpty || widget.category == 'Все') {
          return;
        }

        _showOverlay(context);
      },
      behavior: HitTestBehavior.opaque,

      child: widget.child,
    );
  }
}

class _EditDialog extends StatefulWidget {
  final String category;
  final int index;

  const _EditDialog({required this.category, required this.index});

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  late final _controller = TextEditingController(text: widget.category);
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Переименовать'),

      backgroundColor: Colors.white,

      content: TextField(
        controller: _controller,
        focusNode: _focusNode,

        decoration: InputDecoration(
          hintText: 'Введите новое название категории',
          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: WasubiColors.wasubiNeutral[400]!,
          ),

          labelText: 'Название',
          labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: WasubiColors.wasubiNeutral[400]!,
          ),
          floatingLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
          alignLabelWithHint: true,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: WasubiColors.wasubiNeutral[400]!,
              width: 2.0,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: WasubiColors.wasubiNeutral[400]!,
              width: 2.0,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: const Color(0xFFFF5722), width: 2.0),
          ),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: WasubiColors.wasubiNeutral[400]!,
              width: 2.0,
            ),
          ),

          isDense: true,
        ),

        style: Theme.of(context).textTheme.titleMedium,

        maxLength: 15,

        onTapOutside: (_) {
          _focusNode.unfocus();
        },
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),

          child: const Text('Отмена'),
        ),

        TextButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              BlocProvider.of<CategoryBloc>(
                context,
              ).add(RenameCategoryEvent(widget.index, _controller.text.trim()));

              BlocProvider.of<SubscriptionBloc>(context).add(
                ResetCategoriesEvent(widget.category, _controller.text.trim()),
              );

              Navigator.pop(context);
            }
          },

          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  final String category;
  final int index;

  const _DeleteDialog({required this.category, required this.index});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Удалить категорию'),
      content: Text('Вы уверены, что хотите удалить категорию "$category"?'),

      backgroundColor: Colors.white,

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),

        TextButton(
          onPressed: () {
            context.read<CategoryBloc>().add(DeleteCategoryEvent(category));
            Navigator.pop(context);
          },

          child: const Text('Удалить'),
        ),
      ],
    );
  }
}
