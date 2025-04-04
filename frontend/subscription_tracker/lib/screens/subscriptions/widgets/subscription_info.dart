import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:subscription_tracker/models/category_bloc/category_bloc.dart';
import 'package:subscription_tracker/models/category_bloc/category_event.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/models/subscription_bloc/subscription_event.dart';
import 'package:subscription_tracker/models/subscription_model.dart';
import 'package:subscription_tracker/screens/subscriptions/common/scripts/scripts.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/color_picker.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/date_picker.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/decimal_input.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/divided_list.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/slideable.dart';
import 'package:subscription_tracker/services/shared_data.dart';
import 'package:subscription_tracker/widgets/dropdown_button.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class SubscriptionListItem extends StatelessWidget {
  final SubscriptionModel subscription;

  const SubscriptionListItem({required this.subscription, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),

      child: SlideableWidget(
        rightIcon: Icon(Icons.delete_outlined, color: Colors.red),
        onRightActionPressed: () async {
          _showDeleteDialog(
            context,
            onDeleted: () {
              BlocProvider.of<SubscriptionBloc>(
                context,
              ).add(DeleteSubscriptionEvent(subscription));
            },
          );
        },

        leftIcon: Icon(
          subscription.isActive
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
          color: subscription.isActive ? Colors.blue : Colors.green,
        ),
        onLeftActionPressed: () {
          BlocProvider.of<SubscriptionBloc>(context).add(
            UpdateSubscriptionEvent(
              subscription.copyWith(isActive: !subscription.isActive),
            ),
          );
        },

        child: SubscriptionPreview(subscription: subscription),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, {VoidCallback? onDeleted}) {
    Dialogs.bottomMaterialDialog(
      context: context,

      title: 'Удалить подписку',
      msg: 'Действительно удалить подписку?',

      customView: SizedBox(height: 36.0),
      customViewPosition: CustomViewPosition.AFTER_ACTION,

      actionsBuilder: (context) {
        return [
          IconsButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

            text: 'Отмена',
            iconData: Icons.cancel_outlined,

            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),

          IconsButton(
            onPressed: () {
              Navigator.of(context).pop();

              onDeleted?.call();
            },

            text: 'Удалить',
            iconData: Icons.delete,
            color: Colors.red,

            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ];
      },
    );
  }
}

class SubscriptionPreview extends StatelessWidget {
  final SubscriptionModel subscription;

  const SubscriptionPreview({required this.subscription, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color(subscription.color),
    );

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,

          builder: (bottomSheetCtx) {
            final categoryBloc = BlocProvider.of<CategoryBloc>(context);

            return BlocProvider.value(
              value: categoryBloc,

              child: SubscriptionDetails(
                subscription: subscription,

                onChanged: (newSubs) {
                  BlocProvider.of<SubscriptionBloc>(
                    context,
                  ).add(UpdateSubscriptionEvent(newSubs));
                },
              ),
            );
          },
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),

        decoration: BoxDecoration(
          color:
              subscription.isActive
                  ? colorScheme.primaryContainer
                  : colorScheme.surface,

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
                      subscription.caption,
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      formatCost(
                        subscription.cost,
                        subscription.currency,
                        subscription.interval,
                      ),
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Text(
                      'Следующий платёж: ${formatDate(subscription.firstPay)}',
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
                      getInitials(subscription.caption),

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
  final bool isNew;
  final SubscriptionModel subscription;
  final ValueChanged<SubscriptionModel> onChanged;

  const SubscriptionDetails({
    this.isNew = false,
    required this.subscription,
    required this.onChanged,
    super.key,
  });

  @override
  State<SubscriptionDetails> createState() => _SubscriptionDetailsState();
}

class _SubscriptionDetailsState extends State<SubscriptionDetails> {
  late bool _hasChanged = widget.isNew;
  late var _newSubscription = widget.subscription;
  late final String formattedInitialPeriod = formatPreviewPeriod(
    widget.subscription.interval,
    false,
  );

  late final String formattedInitialTrialPeriod = formatPreviewPeriod(
    widget.subscription.trialInterval ?? 1,
    false,
  );

  @override
  Widget build(BuildContext context) {
    final formattedInterval = formatPreviewPeriod(
      _newSubscription.interval,
      false,
    );

    final formattedTrialInterval = formatPreviewPeriod(
      _newSubscription.trialInterval ?? 1,
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
                      isActive: _newSubscription.isActive,

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

                          child: DecimalInput(
                            value: _newSubscription.cost,
                            currency: _newSubscription.currency,

                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),

                            onChanged: (value) {
                              final newCost =
                                  value.isEmpty ? .0 : double.parse(value);

                              setState(() {
                                _newSubscription = _newSubscription.copyWith(
                                  cost: newCost,
                                );

                                if (newCost != widget.subscription.cost) {
                                  _hasChanged = true;
                                } else if (_newSubscription ==
                                    widget.subscription) {
                                  _hasChanged = false;
                                }
                              });
                            },
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

                          child: DatePicker(
                            value: _newSubscription.firstPay,

                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _newSubscription = _newSubscription.copyWith(
                                  firstPay: value,
                                );

                                if (value != widget.subscription.firstPay) {
                                  _hasChanged = true;
                                } else if (_newSubscription ==
                                    widget.subscription) {
                                  _hasChanged = false;
                                }
                              });
                            },

                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4.0),
                            ),

                            textStyle: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontSize: 16.0,
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

                          child: DatePicker(
                            value: _newSubscription.endDate,

                            onChanged: (value) {
                              setState(() {
                                _newSubscription = _newSubscription.copyWith(
                                  endDate: value,
                                );

                                if (value != widget.subscription.endDate) {
                                  _hasChanged = true;
                                } else if (_newSubscription ==
                                    widget.subscription) {
                                  _hasChanged = false;
                                }
                              });
                            },

                            additionalAction: TextButton(
                              onPressed: () {
                                setState(() {
                                  _newSubscription = _newSubscription.copyWith(
                                    endDate: null,
                                  );

                                  if (null != widget.subscription.endDate) {
                                    _hasChanged = true;
                                  } else if (_newSubscription ==
                                      widget.subscription) {
                                    _hasChanged = false;
                                  }
                                });

                                Navigator.of(context).pop();
                              },

                              child: const Text('Никогда'),
                            ),

                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4.0),
                            ),

                            textStyle: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontSize: 16.0,
                            ),
                          ),
                        ),

                        // notify me
                        // NamedEntry(
                        //   name: 'Уведомить меня',

                        //   child: Align(
                        //     alignment: Alignment.centerRight,

                        //     child: Text(
                        //       'Никогда',

                        //       style: TextStyle(
                        //         color: Colors.grey[900],
                        //         fontSize: 16.0,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
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

                            items:
                                BlocProvider.of<CategoryBloc>(
                                  context,
                                ).state.categories +
                                ['Добавить'],

                            onChanged: (value) async {
                              if (value == 'Добавить') {
                                final newCategory = await _addCategory(context);

                                if (newCategory == null ||
                                    newCategory.isEmpty ||
                                    BlocProvider.of<CategoryBloc>(
                                      context,
                                    ).state.categories.contains(newCategory)) {
                                  return;
                                }

                                value = newCategory;

                                BlocProvider.of<CategoryBloc>(
                                  context,
                                ).add(AddCategoryEvent(newCategory));
                              }

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
                      isActive: _newSubscription.trialActive,
                      label: 'Пробный период',

                      onSwitch: (value) {
                        setState(() {
                          _newSubscription = _newSubscription.copyWith(
                            trialActive: value,
                          );

                          if (value != widget.subscription.trialActive) {
                            _hasChanged = true;
                          } else if (_newSubscription == widget.subscription) {
                            _hasChanged = false;
                          }
                        });
                      },

                      children: [
                        // period
                        NamedEntry(
                          name: 'Период',

                          child: Dropdown<String>(
                            value: formattedTrialInterval,

                            items: [
                              if (!SharedData.intervals.keys.contains(
                                formattedInitialTrialPeriod,
                              )) ...{
                                formattedInitialTrialPeriod,
                              },

                              ...SharedData.intervals.keys,
                            ],

                            onChanged: (value) {
                              setState(() {
                                _newSubscription = _newSubscription.copyWith(
                                  trialInterval: SharedData.intervals[value]!,
                                );

                                if (SharedData.intervals[value]! !=
                                    widget.subscription.trialInterval) {
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

                        // cost
                        NamedEntry(
                          name: 'Цена',

                          child: DecimalInput(
                            value: _newSubscription.trialCost,
                            currency: _newSubscription.currency,

                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),

                            onChanged: (value) {
                              final newCost =
                                  value.isEmpty ? .0 : double.parse(value);

                              setState(() {
                                _newSubscription = _newSubscription.copyWith(
                                  trialCost: newCost,
                                );

                                if (newCost != widget.subscription.trialCost) {
                                  _hasChanged = true;
                                } else if (_newSubscription ==
                                    widget.subscription) {
                                  _hasChanged = false;
                                }
                              });
                            },
                          ),
                        ),

                        // end of trial period
                        NamedEntry(
                          name: 'Конец периода',

                          child: DatePicker(
                            value: _newSubscription.trialEndDate,

                            onChanged: (value) {
                              setState(() {
                                _newSubscription = _newSubscription.copyWith(
                                  trialEndDate: value,
                                );

                                if (value != widget.subscription.trialEndDate) {
                                  _hasChanged = true;
                                } else if (_newSubscription ==
                                    widget.subscription) {
                                  _hasChanged = false;
                                }
                              });
                            },

                            additionalAction: TextButton(
                              onPressed: () {
                                setState(() {
                                  _newSubscription = _newSubscription.copyWith(
                                    trialEndDate: null,
                                  );

                                  if (null !=
                                      widget.subscription.trialEndDate) {
                                    _hasChanged = true;
                                  } else if (_newSubscription ==
                                      widget.subscription) {
                                    _hasChanged = false;
                                  }
                                });

                                Navigator.of(context).pop();
                              },

                              child: const Text('Никогда'),
                            ),

                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4.0),
                            ),

                            textStyle: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontSize: 16.0,
                            ),
                          ),
                        ),

                        // notify me
                        // NamedEntry(
                        //   name: 'Уведомить меня',

                        //   child: Text(
                        //     'Пробный 3',

                        //     style: TextStyle(
                        //       color: Colors.grey[900],
                        //       fontSize: 16.0,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
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
                          name: 'URL',

                          child: _DefaultTextInput(
                            label: _newSubscription.supportLink,
                            hint: 'https://example.com',

                            keyboardType: TextInputType.url,

                            onChanged: (value) {
                              setState(() {
                                _newSubscription = _newSubscription.copyWith(
                                  supportLink: value,
                                );

                                if (value != widget.subscription.supportLink) {
                                  _hasChanged = true;
                                } else if (_newSubscription ==
                                    widget.subscription) {
                                  _hasChanged = false;
                                }
                              });
                            },
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

  Future<String?> _addCategory(BuildContext context) async {
    String? newCategory = await showAdaptiveDialog<String>(
      context: context,

      builder: (dialogCtx) {
        return _AddCategoryDialog();
      },
    );

    return newCategory;
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
  final _captionFocusNode = FocusNode();
  final _commentFocusNode = FocusNode();

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

    _captionFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _captionFocusNode.removeListener(_handleFocusChange);
    _captionFocusNode.dispose();
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

                            _captionFocusNode.requestFocus();
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
                                          focusNode: _captionFocusNode,

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
                  focusNode: _commentFocusNode,

                  onSubmitted: (value) {
                    widget.onCommentChanged(value);
                  },

                  onTapOutside: (_) {
                    _commentFocusNode.unfocus();
                    widget.onCommentChanged(_commentController.text);
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
    if (!_captionFocusNode.hasFocus && _isEditing) {
      setState(() => _isEditing = false);
      widget.onCaptionChanged(_captionController.text);
    }
  }
}

class _DefaultTextInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _DefaultTextInput({
    this.label,
    this.hint,
    this.keyboardType,
    required this.onChanged,
  });

  @override
  State<_DefaultTextInput> createState() => _DefaultTextInputState();
}

class _DefaultTextInputState extends State<_DefaultTextInput> {
  late final _controller = TextEditingController(text: widget.label);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,

      child: TextFormField(
        controller: _controller,

        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,

        keyboardType: widget.keyboardType ?? TextInputType.text,

        maxLines: 1,

        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey),

          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 2.0),
          isDense: true,
        ),

        style: TextStyle(
          color: Colors.blue[400],
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),

        onFieldSubmitted: (value) {
          widget.onChanged(value);
        },

        onTapOutside: (event) {
          widget.onChanged(_controller.text);
        },
      ),
    );
  }
}

class _AddCategoryDialog extends StatefulWidget {
  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),

        duration: const Duration(milliseconds: 300),

        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),

          clipBehavior: Clip.hardEdge,

          child: Container(
            width: 300,
            height: 175,

            decoration: BoxDecoration(color: Colors.white),

            padding: const EdgeInsets.all(16.0),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                const Text(
                  'Добавить категорию',

                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),

                const Text(
                  'Введите название категории',

                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                ),

                const SizedBox(height: 16.0),

                Expanded(
                  child: TextField(
                    controller: textController,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      isCollapsed: true,

                      hintText: 'Музыка',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),

                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),

                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),

                    cursorHeight: 18.0,

                    autofocus: true,
                  ),
                ),

                const SizedBox(height: 16.0),

                SizedBox(
                  height: 36.0,

                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: Text(
                            'Отмена',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, textController.text.trim());
                          },

                          child: Text(
                            'Добавить',

                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
