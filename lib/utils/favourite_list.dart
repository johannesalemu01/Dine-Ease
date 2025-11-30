import 'package:flutter/material.dart';

class FavouriteList extends StatefulWidget {
  const FavouriteList({super.key, required this.labelhead});
  final String labelhead;
  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  final month = DateTime.now().month;
  final date = DateTime.now().day;
  final year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Card(
        color: Colors.white54,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Icon(Icons.list_sharp),
        ),
      ),
      title: Column(
        children: [
          const Text(''),
          Text('Updated $date,$month,$year'),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
