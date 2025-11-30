import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBar(title: const Text('Carts'),),
    );
  }
}