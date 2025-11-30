// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_restaurant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteRestaurantAdapter extends TypeAdapter<FavouriteRestaurant> {
  @override
  final int typeId = 0;

  @override
  FavouriteRestaurant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteRestaurant(
      restaurantName: fields[0] as String,
      createdTime: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteRestaurant obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.restaurantName)
      ..writeByte(1)
      ..write(obj.createdTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteRestaurantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
