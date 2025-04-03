import 'dart:async';

import 'package:flutter/material.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/screens/subscriptions/common/scripts/scripts.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/slideable.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/subscription_info.dart';
import 'package:subscription_tracker/services/shared_data.dart';
import 'package:subscription_tracker/services/subs_api_service.dart';

class InfiniteStreamList extends StatefulWidget {
  final String category;
  final int pageSize;

  const InfiniteStreamList({
    required this.category,
    this.pageSize = 10,
    super.key,
  });

  @override
  State<InfiniteStreamList> createState() => _InfiniteStreamListState();
}

class _InfiniteStreamListState extends State<InfiniteStreamList> {
  final _streamController = StreamController<List<SubscriptionModel>>();
  final _scrollController = ScrollController();

  final _service = SubsApiService.create();
  final _items = <SubscriptionModel>[];

  int _currentPage = 0;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();

    _fetchNextPage(category: widget.category);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchNextPage(category: widget.category);
      }
    });
  }

  @override
  void dispose() {
    _streamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchNextPage({required String category}) async {
    return;

    final response = await _service.getSubscriptions(
      userId: 'deae4c8c-474c-4587-b40b-5bd100154f5f',
      resultType: 'full',
      category: category,
      limit: widget.pageSize,
      offset: _currentPage * widget.pageSize,
    );

    if (response.statusCode == 200) {
      _items.addAll(response.body!);
      SharedData.instance.subscriptions.addAll(response.body!);
      _currentPage++;
      _streamController.add(_items);
    } else if (response.statusCode == 404) {
      setState(() {
        _notFound = true;
      });
    } else {
      throw Exception('Failed to load data ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: SharedData.instance.subscriptions.length,

      physics: const BouncingScrollPhysics(),

      // clipBehavior: Clip.none,
      itemBuilder: (context, index) {
        final currentSubs = SharedData.instance.subscriptions[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (bottomSheetCtx) {
                  return SubscriptionDetails(
                    subscription: currentSubs,
                    onChanged: (newSubs) {
                      setState(() {
                        SharedData.instance.subscriptions[index] = newSubs;
                      });
                    },
                  );
                },
              );
            },

            child: SlideableWidget(
              rightIcon: Icon(Icons.delete_outlined, color: Colors.red),
              onRightActionPressed: () {
                print('Right Action triggered!');
              },

              leftIcon: Icon(
                Icons.pause_circle_outline_rounded,
                color: Colors.blue,
              ),
              onLeftActionPressed: () {
                print('Left Action triggered!');
              },

              child: SubscriptionPreview(
                caption: currentSubs.caption,
                cost: currentSubs.cost,
                currency: currentSubs.currency,
                firstPay: formatDate(currentSubs.firstPay),
                interval: currentSubs.interval,
                color: Color(currentSubs.color),
              ),
            ),
          ),
        );
      },
    );
  }
}
