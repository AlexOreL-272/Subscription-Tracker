import 'package:flutter/material.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/category_selector.dart';
import 'package:subscription_tracker/screens/subscriptions/widgets/infinite_stream_list.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Header(),
          ),

          Expanded(child: Body()),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36.0,
      child: Stack(
        children: [
          Center(
            child: Text(
              'Мои подписки',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: 36.0,
                height: double.infinity,
                child: Center(child: Text('A')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  String _selectedCategory = '';

  List<String> _categories = [
    'Все',
    'Music',
    'Gaming',
    'Food',
    'Lifestyle',
    'Tech',
    'Travel',
    'Entertainment',
    'Sport',
    'Business',
    'Education',
    'Health',
    'Finance',
    'Social',
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),

        CategorySelector(
          tabController: _tabController,
          categories: _categories,
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        ),

        const SizedBox(height: 16.0),

        Expanded(
          // child: OverflowBox(
          //   alignment: Alignment.topLeft,
          //   maxHeight: MediaQuery.of(context).size.height,
          child: InfiniteStreamList(
            key: ValueKey(_selectedCategory),
            category: _selectedCategory == 'Все' ? '' : _selectedCategory,
          ),
        ),
        // ),
      ],
    );
  }
}

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: TabBarView(
//         controller: _tabController,
//         children:
//             categories.map((category) {
//               return Center(child: Text('$category Subscriptions Content'));
//             }).toList(),
//       ),
//     );
//   }
// }
