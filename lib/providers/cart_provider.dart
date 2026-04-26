import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/models/restaurant.dart';

class CartItem {
  final MenuItem item;
  final String restaurantId;
  final String restaurantName;
  int quantity;

  CartItem({
    required this.item,
    required this.restaurantId,
    required this.restaurantName,
    this.quantity = 1,
  });
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(MenuItem item, String restaurantId, String restaurantName) {
    final existingIndex = state.indexWhere(
      (element) => element.item.name == item.name && element.restaurantId == restaurantId,
    );

    if (existingIndex >= 0) {
      final newState = [...state];
      newState[existingIndex].quantity += 1;
      state = newState;
    } else {
      state = [
        ...state,
        CartItem(
          item: item,
          restaurantId: restaurantId,
          restaurantName: restaurantName,
        ),
      ];
    }
  }

  void removeItem(int index) {
    final newState = [...state];
    newState.removeAt(index);
    state = newState;
  }

  void incrementQuantity(int index) {
    final newState = [...state];
    newState[index].quantity += 1;
    state = newState;
  }

  void decrementQuantity(int index) {
    final newState = [...state];
    if (newState[index].quantity > 1) {
      newState[index].quantity -= 1;
      state = newState;
    } else {
      removeItem(index);
    }
  }

  double get totalAmount {
    return state.fold(0, (sum, item) => sum + (item.item.price * item.quantity));
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
