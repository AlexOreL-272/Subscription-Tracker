import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/settings_bloc/settings_bloc.dart';
import 'package:subscription_tracker/bloc/subscription_bloc/subscription_bloc.dart';
import 'package:subscription_tracker/pages/statistics/screens/calendar_screen/widgets/calendar.dart';
import 'package:subscription_tracker/pages/statistics/screens/calendar_screen/widgets/event_tile.dart';
import 'package:subscription_tracker/repo/currency_rates/currency_repo.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<EventTileData>> _events;

  @override
  void initState() {
    super.initState();
    _events = ValueNotifier<List<EventTileData>>([]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final uiTheme = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    final now = DateTime.now();

    final markers = _getMarkers(
      context,
      DateTime(now.year, now.month),
      // TODO: rethink this
      DateTime(now.year, now.month).add(const Duration(days: 365 * 20)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const SizedBox(height: 16.0),

            Calendar(
              markers: markers.keys.toSet(),

              onSelected: (date) {
                final key = DateTime(date.year, date.month, date.day);
                _events.value = markers[key] ?? [];
              },
            ),

            const SizedBox(height: 16.0),

            ValueListenableBuilder(
              valueListenable: _events,

              builder: (context, value, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: value.length,

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),

                      child: EventTile(
                        data: value[index],

                        style: Theme.of(context).textTheme.titleLarge!,

                        decoration: BoxDecoration(
                          color: uiTheme.container,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<EventTileData>> _getMarkers(
    BuildContext context,
    DateTime monthStart,
    DateTime monthEnd,
  ) {
    final markers = <DateTime, List<EventTileData>>{};

    final subs =
        BlocProvider.of<SubscriptionBloc>(
          context,
        ).subsRepo.subscriptions.values;

    final currencyRepo = RepositoryProvider.of<CurrencyRepo>(context);

    final selectedCurrency =
        BlocProvider.of<SettingsBloc>(context).state.currency;

    for (final sub in subs) {
      if (!sub.isActive) continue;

      final endDate = sub.endDate ?? monthEnd;

      if (sub.trialActive &&
          sub.trialEndDate != null &&
          sub.trialInterval != null &&
          sub.trialCost != null) {
        final trialPayments = _getPaymentDates(
          start: monthStart,
          end: monthEnd,
          firstPay: sub.firstPay,
          intervalDays: sub.trialInterval!,
          cutoff:
              sub.trialEndDate!.isBefore(endDate) ? sub.trialEndDate! : endDate,
        );

        for (var date in trialPayments) {
          final key = DateTime(date.year, date.month, date.day);
          markers[key] ??= [];
          markers[key]!.add(
            EventTileData(
              caption: sub.caption,
              cost: currencyRepo.convert(
                sub.trialCost!,
                sub.currency,
                selectedCurrency,
              ),
              currency: selectedCurrency,
            ),
          );
        }

        if (sub.trialEndDate!.isBefore(monthEnd)) {
          final postTrialStart = sub.trialEndDate!.add(const Duration(days: 1));

          final regularCharges = _getPaymentDates(
            start: monthStart,
            end: monthEnd,
            firstPay: postTrialStart,
            intervalDays: sub.interval,
            cutoff: endDate,
          );

          for (var date in regularCharges) {
            final key = DateTime(date.year, date.month, date.day);
            markers[key] ??= [];
            markers[key]!.add(
              EventTileData(
                caption: sub.caption,
                cost: currencyRepo.convert(
                  sub.cost,
                  sub.currency,
                  selectedCurrency,
                ),
                currency: selectedCurrency,
              ),
            );
          }
        }
      } else {
        final regularCharges = _getPaymentDates(
          start: monthStart,
          end: monthEnd,
          firstPay: sub.firstPay.subtract(Duration(days: sub.interval)),
          intervalDays: sub.interval,
          cutoff: endDate,
        );

        for (var date in regularCharges) {
          final key = DateTime(date.year, date.month, date.day);
          markers[key] ??= [];
          markers[key]!.add(
            EventTileData(
              caption: sub.caption,
              cost: currencyRepo.convert(
                sub.cost,
                sub.currency,
                selectedCurrency,
              ),
              currency: selectedCurrency,
            ),
          );
        }
      }
    }

    return markers;
  }

  List<DateTime> _getPaymentDates({
    required DateTime start,
    required DateTime end,
    required DateTime firstPay,
    required int intervalDays,
    required DateTime cutoff,
  }) {
    final payments = <DateTime>[];

    DateTime current = firstPay;

    while (!current.isAfter(cutoff)) {
      if (!current.isBefore(start) && !current.isAfter(end)) {
        payments.add(current);
      }
      current = current.add(Duration(days: intervalDays));
    }

    return payments;
  }
}
