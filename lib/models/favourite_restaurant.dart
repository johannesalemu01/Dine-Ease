import 'package:hive_flutter/hive_flutter.dart';

part 'favourite_restaurant.g.dart';

@HiveType(typeId: 0)
class FavouriteRestaurant {
  @HiveField(0)
  final String restaurantName;
  @HiveField(1)
  final DateTime createdTime;
  @HiveField(2)
  final String? restaurantId;
  const FavouriteRestaurant({
    required this.restaurantName,
    required this.createdTime,
    this.restaurantId,
  });
}
