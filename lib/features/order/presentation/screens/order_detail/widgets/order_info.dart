import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../../controller/order_cubit.dart';
import '../../../controller/order_state.dart';

class OrderInfo extends StatefulWidget {
  const OrderInfo({super.key, required this.order});

  final OrderEntity order;

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().selectOrderStatus(widget.order.status);
  }

  @override
  void didUpdateWidget(covariant OrderInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.status != widget.order.status) {
      context.read<OrderCubit>().selectOrderStatus(widget.order.status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();

    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Information', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: Sizes.spaceBtwSections),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Date Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(widget.order.formattedOrderDate, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),

              // 2. Items Count Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Items'),
                    Text('${widget.order.items.length} Items', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),

              // 3. Status Dropdown Column
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status'),
                    BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, state) {
                        return RoundedContainer(
                          radius: Sizes.cardRadiusSm,
                          padding: const EdgeInsets.symmetric(horizontal: Sizes.sm, vertical: 0),
                          backgroundColor: HelperFunctions.getOrderStatusColor(state.selectedOrderStatus).withValues(alpha: 0.1),
                          child: DropdownButton<OrderStatus>(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            value: state.selectedOrderStatus,
                            underline: const SizedBox(),
                            onChanged: (OrderStatus? newValue) {
                              if (newValue == null) return;
                              cubit.selectOrderStatus(newValue);
                              cubit.updateOrderStatus(widget.order, newValue, context);
                            },
                            items: OrderStatus.values.map((OrderStatus status) {
                              return DropdownMenuItem<OrderStatus>(
                                value: status,
                                child: Text(
                                  status.name.capitalize.toString(),
                                  style: TextStyle(
                                    color: HelperFunctions.getOrderStatusColor(status),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // 4. Total Amount Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total'),
                    Text('\$${widget.order.totalAmount}', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}