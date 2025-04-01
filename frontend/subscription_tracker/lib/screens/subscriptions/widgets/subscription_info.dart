import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/screens/subscriptions/common/scripts/scripts.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/color_picker.dart';
import 'package:subscription_tracker/services/shared_data.dart';
import 'package:subscription_tracker/widgets/dropdown_button.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class SubscriptionPreview extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: color);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
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
                    caption,
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text(
                    formatCost(cost, currency, interval),
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  Text(
                    'Следующий платёж: $firstPay',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
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
                    getInitials(caption),

                    style: TextStyle(fontSize: 24.0, fontFamily: 'Inter'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionDetails extends StatefulWidget {
  final SubscriptionModel subscription;
  final ValueChanged<SubscriptionModel> onChanged;

  const SubscriptionDetails({
    required this.subscription,
    required this.onChanged,
    super.key,
  });

  @override
  State<SubscriptionDetails> createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  bool _hasChanged = false;
  late var _newSubscription = widget.subscription;
  late final String formattedInitialPeriod = formatPreviewPeriod(
    widget.subscription.interval,
    false,
  );

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDate(_newSubscription.firstPay);
    final formattedCost = _newSubscription.cost.toStringAsFixed(2);
    final formattedInterval = formatPreviewPeriod(
      _newSubscription.interval,
      false,
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color(_newSubscription.color),
    );

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
            _newSubscription.caption,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),

          actions: [
            TextButton(
              onPressed: () {
                widget.onChanged(_newSubscription);

                Navigator.pop(context);
              },

              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll<Color>(Colors.transparent),

                splashFactory: NoSplash.splashFactory,
              ),

              child: Text(
                'Сохранить',
                style: TextStyle(
                  color:
                      _hasChanged
                          ? WasubiColors.wasubiPurple
                          : WasubiColors.wasubiNeutral[450],
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // header
                _SubscriptionDetailsHeader(
                  caption: _newSubscription.caption,
                  comment: _newSubscription.comment,
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
                      child: Align(
                        alignment: Alignment.centerRight,

                        child: Text(
                          '$formattedCost ${_newSubscription.currency}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    // currency
                    _NamedEntry(
                      name: 'Валюта',

                      child: Dropdown<String>(
                        value: _newSubscription.currency,

                        items: SharedData.currencies,

                        onChanged: (value) {
                          setState(() {
                            _newSubscription = _newSubscription.copyWith(
                              currency: value!,
                            );

                            if (value != widget.subscription.currency) {
                              _hasChanged = true;
                            } else if (_newSubscription ==
                                widget.subscription) {
                              _hasChanged = false;
                            }
                          });
                        },

                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: colorScheme.onPrimaryContainer,
                        ),

                        buttonTextStyle: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),

                        dropdownTextStyle: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),

                        buttonDecoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4.0),
                        ),

                        dropdownDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: WasubiColors.wasubiNeutral[400]!,
                          ),
                        ),
                      ),
                    ),

                    // next payment
                    _NamedEntry(
                      name: 'Следующая оплата',

                      child: Align(
                        alignment: Alignment.centerRight,

                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    //period
                    _NamedEntry(
                      name: 'Период',

                      child: Dropdown<String>(
                        value: formattedInterval,

                        items: [
                          if (!SharedData.intervals.keys.contains(
                            formattedInitialPeriod,
                          )) ...{
                            formattedInitialPeriod,
                          },

                          ...SharedData.intervals.keys,
                        ],

                        onChanged: (value) {
                          setState(() {
                            _newSubscription = _newSubscription.copyWith(
                              interval: SharedData.intervals[value]!,
                            );

                            if (SharedData.intervals[value]! !=
                                widget.subscription.interval) {
                              _hasChanged = true;
                            } else if (_newSubscription ==
                                widget.subscription) {
                              _hasChanged = false;
                            }
                          });
                        },

                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: colorScheme.onPrimaryContainer,
                        ),

                        buttonTextStyle: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),

                        dropdownTextStyle: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),

                        buttonDecoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4.0),
                        ),

                        dropdownDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: WasubiColors.wasubiNeutral[400]!,
                          ),
                        ),
                      ),
                    ),

                    // subscription end date
                    // _NamedEntry(
                    //   name: 'Подписка истекает',

                    //   child: const SizedBox(),
                    // ),

                    // Notify me
                    // _NamedEntry(
                    //   name: 'Уведомить меня',

                    //   child: const SizedBox(),
                    // ),
                  ],
                ),

                const SizedBox(height: 16.0),

                // additional info
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

                      child: ColorPicker(
                        color: Color(_newSubscription.color),
                        onChanged: (color) {
                          setState(() {
                            final int colorValue = color.toARGB32();

                            _newSubscription = _newSubscription.copyWith(
                              color: colorValue,
                            );

                            if (colorValue != widget.subscription.color) {
                              _hasChanged = true;
                            } else if (_newSubscription ==
                                widget.subscription) {
                              _hasChanged = false;
                            }
                          });
                        },

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: WasubiColors.wasubiNeutral[400]!,
                          ),
                        ),
                      ),
                    ),

                    // category
                    _NamedEntry(
                      name: 'Категория',

                      child: Dropdown<String>(
                        value: _newSubscription.category ?? 'Все',

                        items: SharedData.instance.categories,

                        onChanged: (value) {
                          setState(() {
                            _newSubscription = _newSubscription.copyWith(
                              category: value!,
                            );

                            if (value != widget.subscription.category) {
                              _hasChanged = true;
                            } else if (_newSubscription ==
                                widget.subscription) {
                              _hasChanged = false;
                            }
                          });
                        },

                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: colorScheme.onPrimaryContainer,
                        ),

                        buttonTextStyle: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),

                        dropdownTextStyle: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),

                        buttonDecoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4.0),
                        ),

                        dropdownDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: WasubiColors.wasubiNeutral[400]!,
                          ),
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
                        _newSubscription.supportLink ?? 'https://example.com',
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
                        _newSubscription.supportLink ?? '+7 (XXX) XXX-XX-XX',
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

            SizedBox(height: 28.0, child: child),
          ],
        ),
      ),
    );
  }
}
