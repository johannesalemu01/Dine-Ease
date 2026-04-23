import 'package:dine_ease/models/favourite_restaurant.dart';
import 'package:dine_ease/services/api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'favourite_provider.g.dart';

final listOfRestaurants = Hive.box<FavouriteRestaurant>('favList').values;

@riverpod
Set<FavouriteRestaurant> favouriteList(ref) {
  return listOfRestaurants.toSet();
}

class FavRestaurant extends Notifier<Set<FavouriteRestaurant>> {
  late ApiService _apiService;

  @override
  Set<FavouriteRestaurant> build() {
    _apiService = ref.watch(apiServiceProvider);
    final listBox = Hive.box<FavouriteRestaurant>('favList');
    return listBox.values.toSet();
  }

  void addRestaurant(FavouriteRestaurant restaurant) async {
    if (!state.contains(restaurant)) {
      final listBox = Hive.box<FavouriteRestaurant>('favList');
      listBox.add(restaurant);
      state = {...state, restaurant};
      
      // Sync with backend if we have an ID
      if (restaurant.restaurantId != null) {
        try {
          await _apiService.post('/favorites', {'restaurantId': restaurant.restaurantId});
        } catch (e) {
          print('⚠️ Sync failed: $e');
        }
      }
    }
  }

  void deleteRestaurant(FavouriteRestaurant restaurant) async {
    if (state.contains(restaurant)) {
      final listBox = Hive.box<FavouriteRestaurant>('favList');
      // Hive delete by key is better but since we store as values list:
      final key = listBox.keys.firstWhere((k) => listBox.get(k) == restaurant, orElse: () => null);
      if (key != null) listBox.delete(key);
      
      state = state.where((element) => element != restaurant).toSet();

      // Sync with backend
      if (restaurant.restaurantId != null) {
        try {
          await _apiService.delete('/favorites/${restaurant.restaurantId}');
        } catch (e) {
          print('⚠️ Sync failed: $e');
        }
      }
    }
  }
}

final favRestaurantProvider =
    NotifierProvider<FavRestaurant, Set<FavouriteRestaurant>>(
        () => FavRestaurant());
