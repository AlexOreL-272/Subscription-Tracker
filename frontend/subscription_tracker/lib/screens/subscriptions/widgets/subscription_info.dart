import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/screens/subscriptions/common/scripts/scripts.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/color_picker.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/divided_list.dart';
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

      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

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
                  overlayColor: WidgetStatePropertyAll<Color>(
                    Colors.transparent,
                  ),

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

          body: Theme(
            data: ThemeData(colorScheme: colorScheme),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // header
                    _SubscriptionDetailsHeader(
                      caption: _newSubscription.caption,
                      comment: _newSubscription.comment,

                      onCaptionChanged: (caption) {
                        setState(() {
                          _newSubscription = _newSubscription.copyWith(
                            caption: caption,
                          );

                          if (caption != widget.subscription.caption) {
                            _hasChanged = true;
                          } else if (_newSubscription == widget.subscription) {
                            _hasChanged = false;
                          }
                        });
                      },

                      onCommentChanged: (comment) {
                        setState(() {
                          _newSubscription = _newSubscription.copyWith(
                            comment: comment,
                          );

                          if (comment != widget.subscription.comment) {
                            _hasChanged = true;
                          } else if (_newSubscription == widget.subscription) {
                            _hasChanged = false;
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 16.0),

                    Text(
                      'Основная информация',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // main info
                    DividedNamedList(
                      children: [
                        // cost
                        NamedEntry(
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
                        NamedEntry(
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
                        NamedEntry(
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

                        // period
                        NamedEntry(
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

                        // end of subscription
                        NamedEntry(
                          name: 'Подписка истекает',

                          child: Align(
                            alignment: Alignment.centerRight,

                            child: Text(
                              'Никогда',

                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // notify me
                        NamedEntry(
                          name: 'Уведомить меня',

                          child: Align(
                            alignment: Alignment.centerRight,

                            child: Text(
                              'Никогда',

                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
                    DividedNamedList(
                      children: [
                        // card color
                        NamedEntry(
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
                        NamedEntry(
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

                    // trial period
                    ExpandableDividedNamedList(
                      label: 'Пробный период',
                      children: [
                        // period
                        NamedEntry(
                          name: 'Период',

                          child: Text(
                            'Пробный период',
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // cost
                        NamedEntry(
                          name: 'Цена',

                          child: Text(
                            'Пробный name',
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // end of trial period
                        NamedEntry(
                          name: 'Конец периода',

                          child: Text(
                            'Пробный 2',
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // notify me
                        NamedEntry(
                          name: 'Уведомить меня',

                          child: Text(
                            'Пробный 3',

                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
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
                    DividedNamedList(
                      children: [
                        // support link
                        NamedEntry(
                          name: 'Ссылка',

                          child: Align(
                            alignment: Alignment.centerRight,

                            child: Text(
                              _newSubscription.supportLink ??
                                  'https://example.com',
                              style: TextStyle(
                                color: Colors.blue[400]!,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),

                        // phone
                        NamedEntry(
                          name: 'Телефон',

                          child: Align(
                            alignment: Alignment.centerRight,

                            child: Text(
                              _newSubscription.supportLink ??
                                  '+7 (XXX) XXX-XX-XX',
                              style: TextStyle(
                                color: Colors.blue[400]!,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 160.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionDetailsHeader extends StatefulWidget {
  final String caption;
  final String? comment;
  final bool isActive;

  final ValueChanged<String> onCaptionChanged;
  final ValueChanged<String?> onCommentChanged;

  const _SubscriptionDetailsHeader({
    required this.caption,
    required this.onCaptionChanged,
    required this.onCommentChanged,
    this.comment,
    this.isActive = true,
  });

  @override
  State<_SubscriptionDetailsHeader> createState() =>
      _SubscriptionDetailsHeaderState();
}

class _SubscriptionDetailsHeaderState
    extends State<_SubscriptionDetailsHeader> {
  late final _captionController = TextEditingController(text: widget.caption);
  late final _commentController = TextEditingController(text: widget.comment);

  bool _isEditing = false;
  final _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant _SubscriptionDetailsHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.caption != oldWidget.caption) {
      _captionController.text = widget.caption;
    }

    if (widget.comment != oldWidget.comment) {
      _commentController.text = widget.comment ?? '';
    }
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _captionController.dispose();
    _commentController.dispose();
    super.dispose();
  }

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
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,

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
                          getInitials(_captionController.value.text),
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
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,

                          onTap: () {
                            setState(() {
                              _isEditing = true;
                            });

                            _focusNode.requestFocus();
                          },

                          child: FocusScope(
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                if (!hasFocus) {
                                  setState(() => _isEditing = false);
                                  widget.onCaptionChanged(
                                    _captionController.text,
                                  );
                                }
                              },

                              child:
                                  _isEditing
                                      ? IntrinsicWidth(
                                        child: TextField(
                                          controller: _captionController,
                                          focusNode: _focusNode,

                                          style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w500,
                                          ),

                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            isCollapsed: true,
                                          ),

                                          onSubmitted: (value) {
                                            widget.onCaptionChanged(value);
                                            setState(() => _isEditing = false);
                                          },
                                        ),
                                      )
                                      : AutoSizeText(
                                        widget.caption,
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 16.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                            ),
                          ),
                        ),

                        Row(
                          spacing: 6.0,

                          children: [
                            Icon(
                              Icons.circle,
                              color:
                                  widget.isActive
                                      ? Color.fromARGB(255, 34, 204, 178)
                                      : Color.fromARGB(255, 224, 40, 98),
                              size: 16.0,
                            ),

                            Text(
                              widget.isActive ? 'Активна' : 'Приостановлена',
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

              Divider(color: WasubiColors.wasubiNeutral[400]!, height: 1.0),

              Align(
                alignment: Alignment.topLeft,

                child: TextField(
                  controller: _commentController,

                  onSubmitted: (value) {
                    widget.onCommentChanged(value);
                  },

                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,

                    isCollapsed: true,

                    hintText:
                        widget.comment == null || widget.comment!.isEmpty
                            ? 'Без комментариев...'
                            : null,
                    hintStyle: TextStyle(
                      color: WasubiColors.wasubiNeutral[700]!,
                      fontSize: 14.0,
                    ),
                  ),

                  maxLength: 100,
                  maxLines: null,

                  selectionHeightStyle: ui.BoxHeightStyle.strut,

                  textAlign: TextAlign.left,
                  textInputAction: TextInputAction.done,

                  style: TextStyle(
                    color: WasubiColors.wasubiNeutral[700]!,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _isEditing) {
      setState(() => _isEditing = false);
      widget.onCaptionChanged(_captionController.text);
    }
  }
}
