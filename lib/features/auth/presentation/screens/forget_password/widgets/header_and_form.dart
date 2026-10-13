import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/form/custom_form_field.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/text_strings.dart';

class HeaderAndForm extends StatelessWidget {
  const HeaderAndForm({super.key, required this.email, required this._formKey});
  final TextEditingController email;
  final GlobalKey<FormState> _formKey;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => context.goNamed('login'),
          icon: const Icon(Iconsax.arrow_left),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Text(
          AppTexts.forgetPasswordTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Text(
          AppTexts.forgetPasswordSubTitle,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: Sizes.spaceBtwSections * 2),

        Form(
          key: _formKey,
          child: CustomFormfieldWidget.withdownEar(
            label: AppTexts.email,
            controller: email,
            prefixIcon: Icon(Iconsax.direct_right),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ), // TextFormField
        ), // Form
        const SizedBox(height: Sizes.spaceBtwSections),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.push('/reset', extra: email.text.trim());
              }
            },
            child: const Text(AppTexts.submit),
          ),
        ), // SizedBox
        const SizedBox(height: Sizes.spaceBtwSections * 2),
      ],
    );
  }
}
