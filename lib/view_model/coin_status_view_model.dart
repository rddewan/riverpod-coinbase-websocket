

import 'package:coinbase/repository/coinbase_status_repository.dart';
import 'package:coinbase/state/coin_status_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinStatusViewModelProvider = AutoDisposeNotifierProvider<CoinStatusViewModel,CoinStatusState>(CoinStatusViewModel.new);

class CoinStatusViewModel extends AutoDisposeNotifier<CoinStatusState> {
  @override
  CoinStatusState build() {
    final data = ref.watch(coinbaseStatusRepositoryProvider);

    return CoinStatusState(data: data);
  }

  void reset() {
    ref.invalidate(coinbaseStatusRepositoryProvider);
  }

}