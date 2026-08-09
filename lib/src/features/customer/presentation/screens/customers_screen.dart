import 'package:flutter/material.dart';
import 'package:mobilepos/src/features/customer/presentation/widgets/add_customer_fab.dart';
import 'package:mobilepos/src/features/customer/presentation/widgets/customer_app_bar.dart';
import 'package:mobilepos/src/features/customer/presentation/widgets/customer_tab_bar.dart';
import 'package:mobilepos/src/features/customer/presentation/widgets/empty_customer_view.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomerAppBar(),
        body: Column(
          children: [
            CustomerTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  EmptyCustomerView(),
                  EmptyCustomerView(),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: AddCustomerFAB(),
      ),
    );
  }
}