import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionSumProviders {
  static final StateProviderFamily<double, Object?> creditSumProvider =
      StateProvider.family(
        (ref, arg) => 0.0,
      );

  static final StateProviderFamily<double, Object?> debitSumProvider =
      StateProvider.family(
        (ref, arg) => 0.0,
      );
  static final StateProviderFamily<double, Object?> balanceSumProvider =
      StateProvider.family(
        (ref, arg) => 0.0,
      );
}
