import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/category_bloc/category_bloc.dart';
import 'package:subscription_tracker/bloc/category_bloc/category_event.dart';
import 'package:subscription_tracker/bloc/category_bloc/category_state.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_event.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/bloc/user_bloc/user_state.dart';
import 'package:subscription_tracker/dto/subscriptions/subscriptions_dto.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/pages/subscriptions/widgets/category_selector.dart';
import 'package:subscription_tracker/pages/subscriptions/widgets/subscription_info.dart';
import 'package:subscription_tracker/pages/subscriptions/widgets/subscription_list.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final backgroundColor =
        isDark ? UIBaseColors.backgroundDark : UIBaseColors.backgroundLight;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final isAuthorized = state.authStatus == AuthStatus.authorized;

        return Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.subscriptionsPageTitle,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),

            centerTitle: true,
            backgroundColor: Colors.transparent,

            leading:
                isAuthorized
                    ? IconButton(
                      icon: const Icon(Icons.refresh),

                      onPressed: () {
                        BlocProvider.of<SubscriptionBloc>(
                          context,
                        ).add(FetchSubscriptionsEvent());

                        BlocProvider.of<CategoryBloc>(
                          context,
                        ).add(ForceUpdateCategoriesEvent());
                      },
                    )
                    : null,

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
                            ).add(AddSubscriptionEvent(newSubs));
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

                      child: SubscriptionList(
                        key: ValueKey(category),
                        category: category,
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
