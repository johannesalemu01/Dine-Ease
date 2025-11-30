import 'dart:ui';

import 'package:flutter/material.dart';

class SpecialFood extends StatelessWidget {
  const SpecialFood(
      {super.key,
      required this.width,
      required this.priceTag,
      required this.labelFoodName,
      this.path = 'assets/images/ordinary_burger.png'});

  final double width;
  final String priceTag;
  final String labelFoodName;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            SizedBox(
              height: 170,
              width: width / 3 - 13,
              child: Image.asset(
                path,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.2),
                    child: Text(
                      labelFoodName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            // const Banner(
            //   message: '600 Birr',
            //   location: BannerLocation.topStart,
            //   color: Color.fromARGB(255, 0, 149, 172),
            //   textStyle: TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // )
            Positioned(
              top: 16,
              left: -55,
              child: Transform.rotate(
                angle: -0.785,
                child: Container(
                  alignment: Alignment.center,
                  width: 160,
                  color: const Color.fromARGB(221, 208, 74, 2),
                  // color: const Color.fromARGB(255, 0, 144, 166),
                  child: Text(
                    priceTag,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
