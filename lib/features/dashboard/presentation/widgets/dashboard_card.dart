import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class TDashboardCard extends StatelessWidget {
  const TDashboardCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.stats,
    this.headingIcon,
    this.headingIconColor,
    this.headingIconBgColor,
    this.icon = Iconsax.arrow_up_3,
    this.color = AppColors.success,
    this.onTap,
  });

  final String title, subTitle;
  final IconData icon;
  final Color color;
  final int stats;
  final IconData? headingIcon;
  final Color? headingIconColor;
  final Color? headingIconBgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isSmallDesktop = MediaQuery.of(context).size.width < 1300;

    return RoundedContainer(
      onTap: onTap ?? () {},
      padding: EdgeInsets.all(isSmallDesktop ? Sizes.md : Sizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (headingIcon != null) ...[
                RoundedContainer(
                  padding: const EdgeInsets.all(Sizes.xs),
                  backgroundColor: headingIconBgColor ?? AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(
                    headingIcon,
                    color: headingIconColor ?? AppColors.primary,
                    size: Sizes.iconMd,
                  ),
                ),
                const SizedBox(width: Sizes.spaceBtwItems),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall!.apply(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  subTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Sizes.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: color, size: Sizes.iconSm),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '$stats%',
                            style: Theme.of(context).textTheme.titleMedium!.apply(color: color),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Compared to last week',
                      style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      maxLines: 1,
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