

import 'package:coinbase/view_model/coin_price_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoinPriceScreen extends ConsumerWidget {
  final List<String> productIds;
  const CoinPriceScreen({super.key, required this.productIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Price'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(coinPriceViewModelProvider(productIds).notifier).reset();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, ref, child) {
            final asynValue = ref.watch(coinPriceViewModelProvider(productIds));

            return asynValue.when(
              data: (data) {
                final price  = data['price'] ?? '0';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['product_id'] ?? '-'),
                      Text(price == '0' ? '-' : price),
                      Text(data['time'] ?? '-'),
                    ],
                  ),
                );
                
              },
              error: (e,s) => Center(child: Text(e.toString())), 
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          }),
      ),
    );
  }
}