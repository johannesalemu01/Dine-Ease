import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/providers/restaurant_provider.dart';
import 'package:dine_ease/pages/map_page.dart';
import 'package:dine_ease/utils/restaurants_list.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(restaurantSearchProvider);
    final searchNotifier = ref.read(restaurantSearchProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(height: 50),
          Container(
            color: const Color.fromARGB(255, 50, 48, 48),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 35,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white70,
                        height: 3.5,
                        fontSize: 14,
                      ),
                      cursorColor: Colors.green,
                      cursorHeight: 14,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Colors.green,
                          size: 18,
                        ),
                        hintText: 'Address, Kebele ...',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      onChanged: (value) => searchNotifier.search(value),
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 3.5,
                        fontSize: 14,
                      ),
                      cursorColor: Colors.green,
                      cursorHeight: 14,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          color: Colors.green,
                          size: 18,
                        ),
                        hintText: 'Type of food , restaurant name ...',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.white54),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.shopify_outlined,
                            color: Color.fromARGB(255, 105, 191, 150),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Search all restaurants',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(color: Colors.white38, thickness: 0.5),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Continue exploring',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        'Clear all',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  searchResults.when(
                    data: (results) {
                      if (results.isEmpty) {
                        return const Center(
                          child: Text(
                            'No restaurants found',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 500,
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final restaurant = results[index];
                            return RestaurantsList(restaurant: restaurant);
                          },
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(
                      child: Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityTrends extends StatelessWidget {
  final IconData icon;
  final String labelTop;
  final String labelBottom;
  final VoidCallback? onTap;

  const CommunityTrends({
    required this.icon,
    required this.labelTop,
    required this.labelBottom,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.white54),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Icon(
                    icon,
                    color: const Color.fromARGB(255, 105, 191, 150),
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            RichText(
              text: TextSpan(
                text: '$labelTop\n',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                children: [
                  TextSpan(
                    text: labelBottom,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
