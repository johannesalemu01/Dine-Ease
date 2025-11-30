import 'package:flutter/material.dart';

class RestaurantsList extends StatefulWidget {
  const RestaurantsList({
    super.key,
    required this.imagePath,
    required this.restaurantName,
    required this.price,
    required this.rating,
    required this.location,
  });
  final String imagePath;
  final String restaurantName;
  final double price;
  final double rating;
  final String location;

  @override
  State<RestaurantsList> createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Container(
        margin: const EdgeInsets.only(bottom: 25, right: 2),
        height: 310,
        width: width / 2.03,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(31, 59, 117, 134),
                  Color.fromARGB(31, 59, 117, 134),
                  Colors.black12,
                  Color.fromARGB(31, 59, 117, 134),
                  Color.fromARGB(31, 59, 117, 134),
                ]),
            borderRadius: BorderRadius.circular(12)),
        child: Card(
          elevation: 1,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.imagePath,
                // width: width / 2,
                height: 300 / 1.7,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: Container(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'restaurantName',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: RichText(
                  text: TextSpan(
                    text: 'AveragePrice ',
                    style: const TextStyle(
                        color: Color.fromARGB(235, 255, 255, 255)),
                    children: [
                      TextSpan(
                          text: '${widget.price}',
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                children: [
                  Icon(Icons.pin_drop,
                      color: Color.fromARGB(230, 221, 148, 93)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'kebele 11',
                    style: TextStyle(color: Color.fromARGB(235, 255, 255, 255)),
                  ),
                ],
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 120,
                  ),
                  Icon(Icons.food_bank_rounded,
                      color: Color.fromARGB(255, 245, 154, 105), size: 18),
                  SizedBox(width: 6),
                  Text(
                    '8.6',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(255, 228, 152, 111),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
