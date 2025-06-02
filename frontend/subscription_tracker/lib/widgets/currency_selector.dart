import 'package:flutter/material.dart';
import 'package:subscription_tracker/services/shared_data.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class CurrencySelector extends StatefulWidget {
  final String currency;
  final ValueChanged<String> onChanged;
  final ColorScheme? colorScheme;

  const CurrencySelector({
    super.key,
    required this.currency,
    required this.onChanged,
    this.colorScheme,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  late String _selectedCurrency = widget.currency;

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextButton.icon(
      onPressed: () async {
        final newCurrency = await _selectCurrency(context);

        if (newCurrency != null) {
          setState(() {
            _selectedCurrency = newCurrency;
          });

          widget.onChanged(newCurrency);
        }
      },

      label: Text(
        _selectedCurrency,
        style: textTheme.titleMedium!.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w400,
        ),
      ),

      icon: Icon(
        Icons.keyboard_arrow_right,
        color: colorScheme.onPrimaryContainer,
      ),

      iconAlignment: IconAlignment.end,

      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          colorScheme.primaryContainer,
        ),

        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        ),

        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.only(left: 8.0),
        ),
      ),
    );
  }

  Future<String?> _selectCurrency(BuildContext context) async {
    final currency = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      clipBehavior: Clip.hardEdge,

      builder: (dialogCtx) {
        return _CurrencyScreen(currency: _selectedCurrency);
      },
    );

    return currency;
  }
}

class _CurrencyScreen extends StatefulWidget {
  final String currency;

  const _CurrencyScreen({required this.currency});

  @override
  State<_CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<_CurrencyScreen> {
  late String _selectedCurrency = widget.currency;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final uiColor = isDark ? UIBaseColors.dark() : UIBaseColors.light();

    return Scaffold(
      backgroundColor: uiColor.background,

      appBar: AppBar(
        backgroundColor: uiColor.background,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: uiColor.text),
          onPressed: () => Navigator.pop(context, _selectedCurrency),
        ),

        title: Text(
          'Выберите валюту',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: uiColor.text),
        ),

        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        child: DecoratedBox(
          decoration: BoxDecoration(
            color: uiColor.container,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: uiColor.border),
            boxShadow: [
              BoxShadow(
                color: uiColor.shadow,
                blurRadius: 2.0,
                spreadRadius: 1.0,
              ),
            ],
          ),

          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),

            itemBuilder: (context, index) {
              final label =
                  '${SharedData.currenciesDescriptions[index]} (${SharedData.currencies[index]})';

              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,

                spacing: 8.0,

                children: [
                  if (_selectedCurrency == SharedData.currencies[index]) ...{
                    Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16.0,
                    ),
                  },

                  if (_selectedCurrency != SharedData.currencies[index]) ...{
                    SizedBox(width: 16.0),
                  },

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCurrency = SharedData.currencies[index];
                      });
                    },

                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),

                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(color: uiColor.secondaryText),
                      ),
                    ),
                  ),
                ],
              );
            },

            separatorBuilder: (context, index) => const Divider(height: 1.0),

            itemCount: SharedData.currencies.length,
          ),
        ),
      ),
    );
  }
}
