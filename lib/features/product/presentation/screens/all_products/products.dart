import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../controller/product_attributes/product_attributes_cubit.dart';
import '../../controller/product_cubit.dart';
import '../../controller/product_image/product_image_cubit.dart';
import '../../controller/product_variations/prduct_cariations_cubit.dart';
import 'esponsive_screens/products_desktop.dart';
import 'esponsive_screens/products_mobile.dart';
import 'esponsive_screens/products_tablet.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (context) => sl<ProductImagesCubit>(),
        ),
        BlocProvider(create: (context) => sl<ProductVariationsCubit>()),

        BlocProvider(create: (context) => sl<ProductAttributesCubit>()),
      ],
      child: SiteTemplate(
        mobile: ProductsMobileScreen(),
        desktop: ProductsDesktopScreen(),
        tablet: ProductsTabletScreen(),
      ),
    );
  }
}
