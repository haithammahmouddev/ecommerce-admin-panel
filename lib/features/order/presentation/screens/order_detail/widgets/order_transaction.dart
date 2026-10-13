import 'package:ecommerce_admin_pannal/features/order/domain/entities/order_entity.dart';
import 'package:flutter/material.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/device/device_utility.dart';

class OrderTransactions extends StatelessWidget {
  const OrderTransactions({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  /// "cash_on_delivery" / "master card" -> "Cash On Delivery" / "Master Card"
  String get _paymentMethodName {
    final raw = order.paymentMethod.trim();
    if (raw.isEmpty) return 'Unknown';
    return raw
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  /// Items subtotal, computed from the order's items.
  double get _subtotal => order.items.fold<double>(
    0,
        (sum, item) => sum + item.price * item.quantity,
  );

  /// Subtitle under the payment method.
  /// - If the order stored shipping/tax, show them.
  /// - Otherwise show what is left of the total after the items (shipping + tax).
  String get _feesText {
    final hasBreakdown = order.shippingCost + order.taxCost > 0;
    if (hasBreakdown) {
      return 'Shipping \$${order.shippingCost.toStringAsFixed(2)}'
          '  •  Tax \$${order.taxCost.toStringAsFixed(2)}';
    }
    final extra = order.totalAmount - _subtotal;
    return 'Shipping & Tax \$${(extra < 0 ? 0 : extra).toStringAsFixed(2)}';
  }

  Widget _paymentIcon() {
    final method = order.paymentMethod.toLowerCase();

    // Only PayPal has an asset in the project. Add more (e.g. TImages.visa) here.
    if (method.contains('paypal')) {
      return RoundedImage(imageType: ImageType.asset, image: AppImages.paypal);
    }

    final IconData icon = method.contains('cash')
        ? Icons.payments_outlined
        : method.contains('card') ||
        method.contains('visa') ||
        method.contains('master')
        ? Icons.credit_card
        : Icons.account_balance_wallet_outlined;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(icon, size: 32),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RoundedContainer(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transactions', style: textTheme.headlineMedium),
          const SizedBox(height: Sizes.spaceBtwSections),
          Row(
            children: [
              // Payment method
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Row(
                  children: [
                    _paymentIcon(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment via $_paymentMethodName',
                            style: textTheme.titleLarge,
                          ),
                          Text(_feesText, style: textTheme.labelMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date', style: textTheme.labelMedium),
                    Text(order.formattedOrderDate, style: textTheme.bodyLarge),
                  ],
                ),
              ),

              // Total
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: textTheme.labelMedium),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: textTheme.bodyLarge,
                    ),
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