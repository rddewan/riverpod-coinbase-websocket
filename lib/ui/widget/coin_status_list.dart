

import 'package:coinbase/repository/coinbase_status_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoinStatusList extends ConsumerWidget {
  const CoinStatusList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('CoinStatusList build');
    final asyncValue = ref.watch(coinbaseStatusRepositoryProvider);

    return asyncValue.when(
      data: (data) {
        final coins = data['products'] as List<dynamic>;
        return ListView.builder(
          itemCount: coins.length,
          itemBuilder: (context, index) {
            final coin = coins[index] as Map<String, dynamic>;

            return ListTile(
              title: Text(coin['id'] as String),
              subtitle: Text(coin['status'] as String),
            );
          },
        );

      }, 
      error: (e,s) => Center(child: Text(e.toString())), 
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}