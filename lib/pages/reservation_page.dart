import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dine_ease/models/restaurant.dart';
import 'package:dine_ease/providers/booking/booking_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReservationPage extends ConsumerStatefulWidget {
  final String? restaurantId;
  const ReservationPage({super.key, this.restaurantId});

  @override
  ConsumerState<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends ConsumerState<ReservationPage> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '19:00';
  int _guests = 2;
  String? _selectedRestaurantId;
  List<Restaurant> _restaurants = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  final List<String> _timeSlots = [
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30'
  ];

  @override
  void initState() {
    super.initState();
    _selectedRestaurantId = widget.restaurantId;
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    final restaurants = await ref.read(bookingRepositoryProvider).getRestaurants();
    setState(() {
      _restaurants = restaurants;
      _isLoading = false;
      if (_selectedRestaurantId == null && restaurants.isNotEmpty) {
        _selectedRestaurantId = restaurants.first.id;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xfff7B43f),
              onPrimary: Colors.black,
              surface: Color(0xFF162236),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleReservation() async {
    if (_selectedRestaurantId == null) return;

    setState(() => _isSubmitting = true);

    final booking = await ref.read(bookingRepositoryProvider).createBooking(
      restaurantId: _selectedRestaurantId!,
      date: _selectedDate,
      time: _selectedTime,
      guests: _guests,
    );

    setState(() => _isSubmitting = false);

    if (booking != null) {
      Fluttertoast.showToast(
        msg: 'Reservation confirmed for ${DateFormat('MMM dd').format(_selectedDate)} at $_selectedTime',
        backgroundColor: Colors.green,
      );
      if (mounted) Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Failed to create reservation', backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0E131E),
        body: Center(child: CircularProgressIndicator(color: Color(0xfff7B43f))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E131E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Book a Table', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('RESTAURANT', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: const Color(0xFF162236), borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<String>(
                value: _selectedRestaurantId,
                isExpanded: true,
                dropdownColor: const Color(0xFF162236),
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                items: _restaurants.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList(),
                onChanged: (val) => setState(() => _selectedRestaurantId = val),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'DATE',
                    DateFormat('EEE, MMM dd').format(_selectedDate),
                    Icons.calendar_today,
                    () => _selectDate(context),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInfoCard(
                    'GUESTS',
                    '$_guests People',
                    Icons.people_outline,
                    () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF162236),
                        builder: (context) => _buildGuestPicker(),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('TIME SLOT', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                final time = _timeSlots[index];
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xfff7B43f) : const Color(0xFF162236),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfff7B43f),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'CONFIRM RESERVATION',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: const Color(0xFF162236), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, color: const Color(0xfff7B43f), size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestPicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Number of Guests', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Color(0xfff7B43f), size: 40),
                onPressed: () => setState(() => _guests = _guests > 1 ? _guests - 1 : 1),
              ),
              const SizedBox(width: 30),
              Text('$_guests', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(width: 30),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Color(0xfff7B43f), size: 40),
                onPressed: () => setState(() => _guests = _guests < 20 ? _guests + 1 : 20),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xfff7B43f)),
              child: const Text('DONE', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}