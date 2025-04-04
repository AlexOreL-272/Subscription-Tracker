import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_state.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/subscription_info.dart';

class SubscriptionList extends StatefulWidget {
  final String category;
  final int pageSize;

  const SubscriptionList({
    required this.category,
    this.pageSize = 10,
    super.key,
  });

  @override
  State<SubscriptionList> createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocSelector<
      SubscriptionBloc,
      SubscriptionState,
      List<SubscriptionModel>
    >(
      selector: (state) {
        if (widget.category.isEmpty) {
          return state.subscriptions.values.toList();
        }

        return state.subscriptions.values
            .where((sub) => sub.category == widget.category)
            .toList();
      },

      builder: (context, subscriptions) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: subscriptions.length,

          itemBuilder: (itemBuildCtx, index) {
            return SubscriptionListItem(subscription: subscriptions[index]);
          },
        );
      },
    );
  }
}
