import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/category_bloc/category_bloc.dart';
import 'package:subscription_tracker/models/category_bloc/category_state.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_event.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_state.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/pages/subscriptions/widgets/category_selector.dart';
import 'package:subscription_tracker/pages/subscriptions/widgets/subscription_info.dart';
import 'package:subscription_tracker/pages/subscriptions/widgets/subscription_list.dart';
import 'package:uuid/uuid.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage>
    with TickerProviderStateMixin {
  final List<String> _categories = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _categories.addAll(BlocProvider.of<CategoryBloc>(context).state.categories);
    _updateTabController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateTabController() {
    final categoryCount =
        BlocProvider.of<CategoryBloc>(context).state.categories.length;

    _tabController = TabController(length: categoryCount, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Мои подписки',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.transparent,

        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),

            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,

                builder: (bottomSheetCtx) {
                  return BlocProvider.value(
                    value: BlocProvider.of<CategoryBloc>(context),

                    child: SubscriptionDetails(
                      isNew: true,

                      subscription: SubscriptionModel(
                        id: Uuid().v1(),

                        caption: 'Edit Me',

                        cost: 0.0,
                        currency: 'RUB',

                        firstPay: DateTime.now(),
                        interval: 30,

                        color: 0xFF2196F3,

                        isActive: true,
                        trialActive: false,
                      ),

                      onChanged: (newSubs) {
                        BlocProvider.of<SubscriptionBloc>(
                          bottomSheetCtx,
                        ).add(UpdateSubscriptionEvent(newSubs));
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],

        actionsPadding: EdgeInsets.zero,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),

          child: Padding(
            padding: const EdgeInsets.all(16.0),

            child: CategorySelector(
              tabController: _tabController,

              onChanged: (value) {},
            ),
          ),
        ),
      ),

      body: BlocListener<CategoryBloc, CategoryState>(
        listenWhen:
            (previous, current) => previous.categories != current.categories,

        listener: (context, state) {
          if (mounted) {
            setState(() {
              _categories
                ..clear()
                ..addAll(state.categories);

              _tabController.dispose();
              _updateTabController();
            });
          }
        },

        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),

          children:
              _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),

                  child: _TabViewContent(
                    category: category,
                    controller: _tabController,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

class _TabViewContent extends StatelessWidget {
  final String category;
  final TabController controller;

  const _TabViewContent({required this.category, required this.controller});

  @override
  Widget build(BuildContext context) {
    final currentCategory = category == 'Все' ? '' : category;

    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      buildWhen:
          (previous, current) =>
              previous.subscriptions != current.subscriptions,

      builder: (context, state) {
        return SubscriptionList(category: currentCategory);
      },
    );
  }
}
