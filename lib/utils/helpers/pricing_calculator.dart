class TPricingCalculator {
  static double calculateTotalPrice(double productPrice, String location) {
    double taxAmount = productPrice * getTaxRateForLocation(location);
    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + taxAmount + shippingCost;
    return double.tryParse(totalPrice.toStringAsFixed(2)) ?? 0.0;
  }

  static String calculateShippingCost(double productPrice, String location) {
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(2);
  }

  static String calculateTax(double productPrice, String location) {
    double taxAmount = productPrice * getTaxRateForLocation(location);
    return taxAmount.toStringAsFixed(2);
  }

  static double getTaxRateForLocation(String location) {
    return 0.10;
  }

  static double getShippingCost(String location) {
     return 5.00;
  }
}