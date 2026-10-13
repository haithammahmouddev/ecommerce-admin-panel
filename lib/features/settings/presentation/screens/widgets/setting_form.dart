import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../controller/settings_cubit/settings_cubit.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return RoundedContainer(
      padding: const EdgeInsets.symmetric(
          vertical: Sizes.lg / 2, horizontal: Sizes.md / 2),
      child: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.status == SettingsStatus.success) {
            TLoaders.successSnackBar(
              title: 'Updated',
              context: context,
              message: state.successMessage ??
                  'App Settings updated successfully!',
            );
          }
          if (state.status == SettingsStatus.error) {
            TLoaders.errorSnackBar(
              title: 'Update Error',
              context: context,
              message: state.errorMessage ?? 'Failed to update settings',
            );
          }
        },
        child: Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Settings',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: Sizes.spaceBtwSections),

              // App Name
              TextFormField(
                controller: cubit.appNameController,
                validator: (value) =>
                    Validator.validateEmptyText('App Name', value),
                decoration: const InputDecoration(
                  hintText: 'App Name',
                  label: Text('App Name'),
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),

              // Tax + Shipping
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cubit.taxController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      validator: (value) =>
                          Validator.validateEmptyText('Tax Rate', value),
                      decoration: const InputDecoration(
                        hintText: 'Tax %',
                        label: Text('Tax Rate (%)'),
                        prefixIcon: Icon(Iconsax.tag),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems + 5),
                  Expanded(
                    child: TextFormField(
                      controller: cubit.shippingController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      validator: (value) =>
                          Validator.validateEmptyText('Shipping Cost', value),
                      decoration: const InputDecoration(
                        hintText: 'Shipping Cost',
                        label: Text('Shipping Cost (\$)'),
                        prefixIcon: Icon(Iconsax.ship),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwItems + 5),

              // Free shipping threshold (optional: empty = no free shipping)
              TextFormField(
                controller: cubit.freeShippingThresholdController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Free Shipping After (\$) - optional',
                  label: Text('Free Shipping Threshold (\$)'),
                  prefixIcon: Icon(Iconsax.ship),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields * 2),

              // Submit
              BlocSelector<SettingsCubit, SettingsState, bool>(
                selector: (state) => state.isFormLoading,
                builder: (context, isFormLoading) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isFormLoading
                          ? null
                          : () => cubit.updateSettingInformation(),
                      child: isFormLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text('Update App Settings'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}