import 'package:coinbase/repository/coinbase_price_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final coinPriceViewModelProvider = AutoDisposeNotifierProviderFamily<CoinPriceViewModel,AsyncValue,List<String>>(CoinPriceViewModel.new);


class CoinPriceViewModel extends AutoDisposeFamilyNotifier<AsyncValue, List<String>> {
  @override
  AsyncValue build(List<String> arg) {
    final  priceStream = ref.watch(coinbasePriceRepositoryProvider(arg));
    return priceStream;
  }

  void reset() {
    ref.invalidate(coinbasePriceRepositoryProvider);
  }
  
}