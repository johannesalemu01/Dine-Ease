import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong2.dart';
import 'package:location/location.dart' as loc;
import 'package:dine_ease/models/restaurant.dart';
import 'package:dine_ease/providers/booking/booking_repository.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final MapController _mapController = MapController();
  loc.LocationData? _currentLocation;
  List<Restaurant> _nearbyRestaurants = [];
  bool _isLoading = true;

  static const LatLng _initialPosition = LatLng(9.0306, 38.7468); // Addis Ababa

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    final currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
    });

    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      await _fetchNearby(currentLocation.latitude!, currentLocation.longitude!);
      _animateToUser();
    }
  }

  Future<void> _fetchNearby(double lat, double lng) async {
    final restaurants = await ref.read(bookingRepositoryProvider).getNearbyRestaurants(lat, lng);
    setState(() {
      _nearbyRestaurants = restaurants;
      _isLoading = false;
    });
  }

  void _animateToUser() {
    if (_currentLocation == null) return;
    _mapController.move(
      LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialPosition,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.dine_ease',
              ),
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      point: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                  ..._nearbyRestaurants.map((r) {
                    return Marker(
                      point: LatLng(r.lat ?? 0, r.lng ?? 0),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Navigate to restaurant detail
                        },
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xfff7B43f),
                          size: 40,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xfff7B43f))),
        ],
      ),
    );
  }
}
