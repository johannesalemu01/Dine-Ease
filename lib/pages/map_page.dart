import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:dine_ease/models/restaurant.dart';
import 'package:dine_ease/providers/booking/booking_repository.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  LocationData? _currentLocation;
  List<Restaurant> _nearbyRestaurants = [];
  bool _isLoading = true;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(9.0306, 38.7468), // Default to Addis Ababa
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
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

  Future<void> _animateToUser() async {
    if (_currentLocation == null) return;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 15,
      ),
    ));
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
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _nearbyRestaurants.map((r) {
              return Marker(
                markerId: MarkerId(r.id),
                position: LatLng(r.lat ?? 0, r.lng ?? 0),
                infoWindow: InfoWindow(
                  title: r.name,
                  snippet: '${r.cuisine} - ${r.rating} ⭐',
                ),
                onTap: () {
                  // TODO: Navigate to restaurant detail
                },
              );
            }).toSet(),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xfff7B43f))),
        ],
      ),
    );
  }
}
