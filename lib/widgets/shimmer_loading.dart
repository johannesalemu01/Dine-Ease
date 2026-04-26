import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantShimmer extends StatelessWidget {
  final bool isHorizontal;
  const RestaurantShimmer({super.key, this.isHorizontal = true});

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Shimmer.fromColors(
        baseColor: const Color(0xFF162236),
        highlightColor: const Color(0xFF1D2D44),
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          height: 300,
          width: MediaQuery.of(context).size.width / 1.6,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: const Color(0xFF162236),
        highlightColor: const Color(0xFF1D2D44),
        child: Container(
          margin: const EdgeInsets.only(bottom: 25, right: 2),
          height: 310,
          width: MediaQuery.of(context).size.width / 2.03,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}

class ShimmerList extends StatelessWidget {
  final int count;
  final bool isHorizontal;
  const ShimmerList({super.key, this.count = 3, this.isHorizontal = true});

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(count, (index) => const RestaurantShimmer(isHorizontal: true)),
        ),
      );
    } else {
      return Wrap(
        children: List.generate(count, (index) => const RestaurantShimmer(isHorizontal: false)),
      );
    }
  }
}
