import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/screens/subscriptions/common/scripts/scripts.dart';

class SubscriptionPreview extends StatefulWidget {
  final String caption;
  final double cost;
  final String currency;
  final String firstPay;
  final int interval;
  final Color color;

  const SubscriptionPreview({
    super.key,
    required this.caption,
    required this.cost,
    required this.currency,
    required this.firstPay,
    required this.interval,
    required this.color,
  });

  @override
  State<SubscriptionPreview> createState() => _SubscriptionPreviewState();
}

class _SubscriptionPreviewState extends State<SubscriptionPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        print(details.primaryDelta);
      },

      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.0,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Text(
                      widget.caption,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      formatCost(widget.cost, widget.currency, widget.interval),
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    Text(
                      'Следующий платёж: ${widget.firstPay}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: Center(
                    child: Text(
                      getInitials(widget.caption),
                      style: TextStyle(fontSize: 24.0, fontFamily: 'Inter'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubscriptionDetails extends StatefulWidget {
  final SubscriptionModel subscription;

  const SubscriptionDetails({required this.subscription, super.key});

  @override
  State<SubscriptionDetails> createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDate(widget.subscription.firstPay);
    final formattedCost = widget.subscription.cost.toStringAsFixed(2);
    final formattedInterval = formatPeriod(widget.subscription.interval);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            widget.subscription.caption,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                _SubscriptionDetailsHeader(
                  caption: widget.subscription.caption,
                  comment: widget.subscription.comment,
                ),

                const SizedBox(height: 16.0),

                const Text(
                  'Основная информация',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // main info
                _DividedNamedList(
                  children: [
                    // cost
                    _NamedEntry(
                      name: 'Цена',
                      child: Text(
                        '$formattedCost ${widget.subscription.currency}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    // currency
                    _NamedEntry(
                      name: 'Валюта',
                      child: Text(
                        widget.subscription.currency,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    // next payment
                    _NamedEntry(
                      name: 'Следующая оплата',
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    //period
                    _NamedEntry(
                      name: 'Период',
                      child: Text(
                        formattedInterval,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                const Text(
                  'Дополнительная информация',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // additional info
                _DividedNamedList(
                  children: [
                    // card color
                    _NamedEntry(
                      name: 'Цвет карточки',
                      child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: darkenColor(
                                Color(widget.subscription.color),
                                0.2,
                              ),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Color(widget.subscription.color),
                              radius: 10.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // category
                    _NamedEntry(
                      name: 'Категория',
                      child: Text(
                        widget.subscription.category ?? 'Все',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                const Text(
                  'Контактная информация',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // contact info
                _DividedNamedList(
                  children: [
                    // support link
                    _NamedEntry(
                      name: 'Ссылка',
                      child: Text(
                        widget.subscription.supportLink ??
                            'https://example.com',
                        style: TextStyle(
                          color: Colors.blue[400]!,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    // phone
                    _NamedEntry(
                      name: 'Телефон',
                      child: Text(
                        widget.subscription.supportLink ?? '+7 (XXX) XXX-XX-XX',
                        style: TextStyle(
                          color: Colors.blue[400]!,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionDetailsHeader extends StatelessWidget {
  final String caption;
  final String? comment;
  final bool _isActive = true;

  const _SubscriptionDetailsHeader({required this.caption, this.comment});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 248, 249, 250),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: Colors.grey[200]!, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 8.0,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,

                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SizedBox(
                      width: 84.0,
                      height: 84.0,
                      child: Center(
                        child: Text(
                          getInitials(caption),
                          style: TextStyle(fontSize: 42.0, fontFamily: 'Inter'),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        AutoSizeText(
                          caption,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          minFontSize: 16.0,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Row(
                          spacing: 6.0,
                          children: [
                            Icon(
                              Icons.circle,
                              color:
                                  _isActive
                                      ? Color.fromARGB(255, 34, 204, 178)
                                      : Color.fromARGB(255, 224, 40, 98),
                              size: 16.0,
                            ),

                            Text(
                              _isActive ? 'Активна' : 'Приостановлена',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Divider(color: Color.fromARGB(255, 203, 207, 214)),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  comment ?? 'Без комментариев...',
                  style: TextStyle(
                    color: Colors.grey[850]!,
                    fontSize: 14.0,
                    // fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DividedNamedList extends StatelessWidget {
  final List<_NamedEntry> children;

  const _DividedNamedList({required this.children});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 248, 249, 250),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: Colors.grey[200]!, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
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
              if (i != children.length - 1) const Divider(height: 1.0),
            ],
          ],
        ),
      ),
    );
  }
}

class _NamedEntry extends StatelessWidget {
  final String name;
  final Widget child;

  const _NamedEntry({required this.name, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.0,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            child,
          ],
        ),
      ),
    );
  }
}
