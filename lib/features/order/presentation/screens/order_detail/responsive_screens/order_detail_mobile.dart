
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../../controller/order_cubit.dart';
import '../../../controller/order_state.dart';
import '../widgets/customer_info.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transaction.dart';

class OrderDetailMobileScreen extends StatelessWidget {
  const OrderDetailMobileScreen({super.key, required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          final currentOrder = state.allItems.firstWhere(
                (o) => o.id == order.id,
            orElse: () => order,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentOrder.id,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections / 2),
                  Column(
                    children: [
                      OrderInfo(order: currentOrder),
                      const SizedBox(height: Sizes.spaceBtwSections),
                      OrderItems(order: currentOrder),
                      const SizedBox(height: Sizes.spaceBtwSections),
                      OrderTransactions(order: currentOrder),
                      const SizedBox(height: Sizes.spaceBtwSections),
                      OrderCustomerInfo(order: currentOrder),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}