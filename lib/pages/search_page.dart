import 'package:flutter/material.dart';
import 'package:dine_ease/pages/map_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: 50,
          ),
          Container(
            color: const Color.fromARGB(255, 50, 48, 48),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: TextField(
                      style: TextStyle(
                          color: Colors.white70, height: 3.5, fontSize: 14),
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
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      style: TextStyle(
                          color: Colors.white70, height: 3.5, fontSize: 14),
                      cursorColor: Colors.green,
                      cursorHeight: 14,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          color: Colors.green,
                          size: 18,
                        ),
                        hintText: 'Type of food , restaurant name ...',
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
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
                            border: Border.all(color: Colors.white54)),
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.shopify_outlined,
                            color: Color.fromARGB(255, 105, 191, 150),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'Search all restaurants',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  color: Colors.white38,
                  thickness: 0.5,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 93, 91, 91),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.history_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      RichText(
                        text: const TextSpan(
                            text: 'Kebele 11\n',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            children: [TextSpan(text: 'Bahirdar')]),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.clear,
                        color: Colors.white70,
                        size: 22,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 450,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Community trends',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              CommunityTrends(
                                labelTop: 'Recommended by TheMesob',
                                labelBottom: 'Best rated',
                                icon: Icons.fastfood_outlined,
                              ),
                              CommunityTrends(
                                labelTop: 'Cuisine',
                                labelBottom: 'Traditional',
                                icon: Icons.restaurant_menu_outlined,
                              ),
                              CommunityTrends(
                                labelTop: 'Cuisine',
                                labelBottom: 'Italian',
                                icon: Icons.restaurant_outlined,
                              ),
                              CommunityTrends(
                                labelTop: 'Setting and moments',
                                labelBottom: 'Reserve',
                                icon: Icons.table_restaurant_rounded,
                              ),
                              CommunityTrends(
                                labelTop: 'Restaurant features',
                                labelBottom: 'BedRoom',
                                icon: Icons.bathroom_outlined,
                              ),
                              CommunityTrends(
                                labelTop: 'TheMosob selection',
                                labelBottom: 'Nearby restaurants',
                                icon: Icons.balcony_rounded,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MapPage(),
                                  ),
                                ),
                              ),
                              CommunityTrends(
                                labelTop: 'TheMosob selection',
                                labelBottom: 'New Restaurants',
                                icon: Icons.balcony_rounded,
                              ),
                              CommunityTrends(
                                labelTop: 'Dishes',
                                labelBottom: 'Dorowot',
                                icon: Icons.restaurant_outlined,
                              ),
                              CommunityTrends(
                                labelTop: 'TheMosob',
                                labelBottom: 'Top 10 Bahirdar',
                                icon: Icons.restaurant_outlined,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.white54)),
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
            const SizedBox(
              width: 12,
            ),
            RichText(
              text: TextSpan(
                text: '$labelTop\n',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                children: [
                  TextSpan(
                      text: labelBottom,
                      style: const TextStyle(color: Colors.white, fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
