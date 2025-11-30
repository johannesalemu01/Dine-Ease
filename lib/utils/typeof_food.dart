import 'package:flutter/material.dart';

class FoodType extends StatelessWidget {
  const FoodType(
    this.foodType, {
    super.key,
    required this.width, 
   this.path='asssets/images/ordinary_burger.png',
  });

  final double width;
  final String foodType;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
          ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xff161e2f),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Card(
                  shape: const CircleBorder(),
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  color: const Color(0xff0D1B2A),
                  child: Image.asset(
                    path,
                    width: width * 0.13,
                    height: width * 0.13,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                foodType,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
