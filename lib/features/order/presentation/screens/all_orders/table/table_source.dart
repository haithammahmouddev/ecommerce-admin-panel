import 'package:data_table_2/data_table_2.dart';
import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import 'package:ecommerce_admin_pannal/features/order/presentation/controller/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../categories/presentation/screens/all_categories/table/table_action_icon_button.dart';

class OrderRows extends DataTableSource {
  final BuildContext context;
  OrderRows({required this.context});
  late final cubit = context.read<OrderCubit>();

  @override
  DataRow? getRow(int index) {
    final orders = cubit.state.filteredItems;

    if (index >= orders.length) return null;

    final order = orders[index];
    return DataRow2(
      // 🔥 تمرير الـ Order والـ Cubit معاً عبر extra
      onTap: () => context.push(
        '/orders/order-detail',
        extra: {'order': order, 'cubit': cubit},
      ),
      selected: cubit.state.selectedRows[index],
      onSelectChanged: (value) => cubit.toggleRowSelection(index, value),
      cells: [
        DataCell(
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              order.id,
              style: Theme.of(context).textTheme.bodyLarge!.apply(color: AppColors.primary),
            ),
          ),
        ),
        DataCell(Text(order.formattedOrderDate)),
        DataCell(Text('${order.items.length} Items')),
        DataCell(
          RoundedContainer(
            radius: Sizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(vertical: Sizes.sm, horizontal: Sizes.md),
            backgroundColor:
            HelperFunctions.getOrderStatusColor(order.status).withOpacity(0.1),
            child: Text(
              order.status.name.capitalize.toString(),
              style: TextStyle(color: HelperFunctions.getOrderStatusColor(order.status)),
            ),
          ),
        ),
        DataCell(Text('\$${order.totalAmount}')),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: false,
            // 🔥 تمرير الـ Order والـ Cubit هنا أيضاً
            onViewPressed: () => context.push(
              '/orders/order-detail',
              extra: {'order': order, 'cubit': cubit},
            ),
            onDeletePressed: () => confirmAndDeleteOrder(
              context: context,
              order: order,
              controller: cubit,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cubit.state.filteredItems.length;

  @override
  int get selectedRowCount => cubit.state.selectedRows
      .where((selected) => selected)
      .length;
}

void confirmAndDeleteOrder({
  required BuildContext context,
  required OrderEntity order,
  required OrderCubit controller,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Order'),
      content: const Text('Are you sure you want to delete this Order?'),
      actions: [
        SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () {
              dialogContext.pop();
              controller.deleteOnConfirm(order, context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Ok'),
          ),
        ),
        SizedBox(
          width: 60,
          child: OutlinedButton(
            onPressed: () => dialogContext.pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
      ],
    ),
  );
}