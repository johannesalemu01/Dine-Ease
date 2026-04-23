import 'package:flutter/material.dart';
import 'package:dine_ease/models/restaurant.dart';

class RestaurantsList extends StatefulWidget {
  const RestaurantsList({
    super.key,
    required this.restaurant,
  });
  final Restaurant restaurant;

  @override
  State<RestaurantsList> createState() => _RestaurantsListState();
}

class _RestaurantsListState extends State<RestaurantsList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final isNetworkImage = widget.restaurant.images.isNotEmpty && widget.restaurant.images[0].startsWith('http');
    final imagePath = widget.restaurant.images.isNotEmpty ? widget.restaurant.images[0] : 'assets/images/restaurants/restaurant-7.jpg';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/reservation_page', arguments: widget.restaurant),
      child: ClipRRect(
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
                isNetworkImage
                    ? Image.network(
                        imagePath,
                        height: 300 / 1.7,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 300 / 1.7,
                          color: Colors.grey[800],
                          child: const Icon(Icons.broken_image, color: Colors.white),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        height: 300 / 1.7,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurant.name,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'AveragePrice ',
                      style: const TextStyle(color: Color.fromARGB(235, 255, 255, 255)),
                      children: [
                        TextSpan(
                            text: '${widget.restaurant.averagePrice}',
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.pin_drop, color: Color.fromARGB(230, 221, 148, 93)),
                    const SizedBox(width: 5),
                    Text(
                      widget.restaurant.address,
                      style: const TextStyle(color: Color.fromARGB(235, 255, 255, 255)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 120),
                    const Icon(Icons.food_bank_rounded, color: Color.fromARGB(255, 245, 154, 105), size: 18),
                    const SizedBox(width: 6),
                    Text(
                      widget.restaurant.rating.toString(),
                      style: const TextStyle(
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
      ),
    );
  }
}
