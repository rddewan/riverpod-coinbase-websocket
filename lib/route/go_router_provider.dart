


import 'package:coinbase/ui/screen/coin_price_screen.dart';
import 'package:coinbase/ui/screen/coin_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const CoinStatusScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'price/:productId',
            builder: (BuildContext context, GoRouterState state) {
              final productId = state.pathParameters['productId'] ?? '';
              
              return CoinPriceScreen(
                productIds: [productId],
              );
            },
          )

        ]
      )

    ],
  );
});