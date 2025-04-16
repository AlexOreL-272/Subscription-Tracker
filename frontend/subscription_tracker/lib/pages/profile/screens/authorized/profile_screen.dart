import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_state.dart';
import 'package:subscription_tracker/pages/subscriptions/common/scripts/scripts.dart';
import 'package:subscription_tracker/widgets/divided_list.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const noData = 'Н/Д';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final fullName = state.fullName ?? noData;
        final splitted = fullName.split(' ');
        final name = splitted.first;
        final middleName = splitted.length > 1 ? splitted.last : noData;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 16.0),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey[300]!),
                    ),

                    child: SizedBox(
                      width: 84.0,
                      height: 84.0,

                      child: Center(
                        child: Text(
                          getInitials(state.fullName ?? 'No Name'),
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: UIBaseColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16.0),

                  Expanded(
                    child: Text(
                      BlocProvider.of<UserBloc>(context).state.fullName ??
                          'No Name',

                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // main info
              Text(
                'Ваши данные',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // main info
              DividedNamedList(
                children: [
                  NamedEntry(
                    name: 'Фамилия',
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(state.surname ?? noData),
                    ),
                  ),

                  NamedEntry(
                    name: 'Имя',
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(name),
                    ),
                  ),

                  NamedEntry(
                    name: 'Отчество',
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(middleName),
                    ),
                  ),

                  NamedEntry(
                    name: 'E-Mail',
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(state.email ?? noData),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
