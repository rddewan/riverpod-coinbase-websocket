

import 'package:coinbase/ui/widget/coin_status_list.dart';
import 'package:coinbase/ui/widget/refresh_button_widget.dart';
import 'package:flutter/material.dart';


class CoinStatusScreen extends StatefulWidget {
  const CoinStatusScreen({ super.key });

  @override
  State createState() => _CoinStatusScreenState();
}

class _CoinStatusScreenState extends State<CoinStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Status'),
        actions: const [
          RefreshButton(),
        ],
      ),
      body: const CoinStatusList(),
    );
  }
}