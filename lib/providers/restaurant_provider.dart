import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/models/restaurant.dart';
import 'package:dine_ease/providers/booking/booking_repository.dart';

final restaurantsProvider = FutureProvider<List<Restaurant>>((ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getRestaurants();
});

final nearbyRestaurantsProvider = FutureProvider<List<Restaurant>>((ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  // Default to Bahir Dar coordinates if none provided
  return repository.getNearbyRestaurants(11.59, 37.39);
});

final cuisineRestaurantsProvider = FutureProvider.family<List<Restaurant>, String>((ref, cuisine) async {
  final repository = ref.watch(bookingRepositoryProvider);
  if (cuisine.isEmpty || cuisine == 'All') {
    return repository.getRestaurants();
  }
  
  // Re-using the getRestaurants but with a potential future update to repository for filtering
  // For now, filtering locally to ensure it works with current repository
  final all = await repository.getRestaurants();
  return all.where((r) => r.cuisine.toLowerCase().contains(cuisine.toLowerCase())).toList();
});

class RestaurantSearchNotifier extends StateNotifier<AsyncValue<List<Restaurant>>> {
  final BookingRepository _repository;
  RestaurantSearchNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final results = await _repository.searchRestaurants(query);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final restaurantSearchProvider = StateNotifierProvider<RestaurantSearchNotifier, AsyncValue<List<Restaurant>>>((ref) {
  final repository = ref.watch(bookingRepositoryProvider);
  return RestaurantSearchNotifier(repository);
});
