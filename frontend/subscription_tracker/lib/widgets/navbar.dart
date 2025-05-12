import 'package:flutter/material.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatefulWidget {
  final void Function(int) onTapped;

  const NavBar({required this.onTapped, super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0,

      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 3;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: _selectedIndex * itemWidth,

                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SizedBox(width: itemWidth, height: height),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: NavBarItem(
                      isSelected: _selectedIndex == 0,
                      label:
                          AppLocalizations.of(
                            context,
                          )!.subscriptionsPageNavBarLabel,
                      icon: Icons.menu,
                      onTapped: () {
                        widget.onTapped(0);
                        setState(() => _selectedIndex = 0);
                      },
                    ),
                  ),

                  Expanded(
                    child: NavBarItem(
                      isSelected: _selectedIndex == 1,
                      label:
                          AppLocalizations.of(
                            context,
                          )!.statisticsPageNavBarLabel,
                      icon: Icons.insert_chart_outlined_sharp,
                      onTapped: () {
                        widget.onTapped(1);
                        setState(() => _selectedIndex = 1);
                      },
                    ),
                  ),

                  Expanded(
                    child: NavBarItem(
                      isSelected: _selectedIndex == 2,
                      label:
                          AppLocalizations.of(context)!.profilePageNavBarLabel,
                      icon: Icons.person_outline_rounded,
                      onTapped: () {
                        widget.onTapped(2);
                        setState(() => _selectedIndex = 2);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final bool isSelected;

  final String label;
  final IconData icon;

  final VoidCallback onTapped;

  const NavBarItem({
    required this.isSelected,
    required this.label,
    required this.icon,
    required this.onTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : WasubiColors.wasubiNeutral[600],
            size: 24.0,
          ),

          Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : WasubiColors.wasubiNeutral[600],
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
