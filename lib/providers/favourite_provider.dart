import 'package:dine_ease/models/favourite_restaurant.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'favourite_provider.g.dart';

final listOfRestaurants = Hive.box<FavouriteRestaurant>('favList').values;

@riverpod
Set<FavouriteRestaurant> favouriteList(ref) {
  return listOfRestaurants.toSet();
}

class FavRestaurant extends Notifier<Set<FavouriteRestaurant>> {
  @override
  Set<FavouriteRestaurant> build() {
    final listBox = Hive.box('favList');
    return listBox.values.cast<FavouriteRestaurant>().toSet();
  }

  void addRestaurant(FavouriteRestaurant restaurant) {
    if (!state.contains(restaurant)) {
      final listBox = Hive.box('favList');
      listBox.add(restaurant);
      state = {...state, restaurant};
    }
  }

  void deleteRestaurant(FavouriteRestaurant restaurant) {
    if (state.contains(restaurant)) {
      final listBox = Hive.box('favList');
      listBox.delete(restaurant);
      state = state.where((element) => element != restaurant).toSet();
    }
  }
}

final favRestaurantProvider =
    NotifierProvider<FavRestaurant, Set<FavouriteRestaurant>>(
        () => FavRestaurant());
