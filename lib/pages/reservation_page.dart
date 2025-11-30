import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
 State<ReservationPage> createState() => _ReservationPage();
}

class _ReservationPage extends State<ReservationPage> {
  @override
  Widget build(BuildContext context){
    return  Scaffold(
      appBar: AppBar(title: const Text('Reservation'),
      centerTitle: true,
      ),
      
    );
  }
}