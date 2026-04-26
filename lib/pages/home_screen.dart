import 'package:carousel_slider/carousel_slider.dart';
import 'package:dine_ease/models/restaurant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dine_ease/providers/restaurant_provider.dart';
import 'package:dine_ease/utils/restaurants_list.dart';
import 'package:dine_ease/utils/special_foods.dart';
import 'package:dine_ease/utils/typeof_food.dart';
import 'package:dine_ease/widgets/shimmer_loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var imagePath = 'assets/images/gallery';
    final restaurantsAsync = ref.watch(restaurantsProvider);
    final nearbyAsync = ref.watch(nearbyRestaurantsProvider);

    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff0e131e),

      //box color 0D1B2A,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(restaurantsProvider);
          ref.refresh(nearbyRestaurantsProvider);
          return Future.delayed(const Duration(milliseconds: 500));
        },
        backgroundColor: const Color(0xff162236),
        color: const Color(0xfff7B43f),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 30,
                color: const Color.fromARGB(124, 242, 207, 166),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11.0),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mesob',
                                style: TextStyle(
                                  height: -0.9,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xcc1098AD),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Food ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 240, 150, 33),
                                    ),
                                  ),
                                  Text(
                                    'Orders',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 240, 150, 33),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/cart_page');
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(181, 81, 92, 184),
                                ),
                                child: const Icon(
                                  Icons.shopping_cart,
                                  color: Color.fromARGB(227, 255, 255, 255),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: ( context){
                                //  return const SearchPage();
                                Navigator.pushNamed(context, '/search_page');
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xfff5ab71),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: SizedBox(
                      height: width * 0.26,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          FoodType(
                            width: width,
                            'Traditional',
                            path: '$imagePath-1.jpg',
                          ),
                          FoodType(
                            width: width,
                            'Modern',
                            path: '$imagePath-2.jpg',
                          ),
                          FoodType(
                            width: width,
                            'Vegan',
                            path: '$imagePath-3.jpg',
                          ),
                          FoodType(
                            width: width,
                            'Desert',
                            path: '$imagePath-4.jpg',
                          ),
                          FoodType(
                            width: width,
                            'Italian',
                            path: '$imagePath-5.jpg',
                          ),
                          FoodType(
                            width: width,
                            'Mexican',
                            path: '$imagePath-6.jpg',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Special Foods',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'See more',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 251, 147, 91),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SpecialFood(
                                  width: width,
                                  labelFoodName: 'lazagna',
                                  priceTag: '100 Birr',
                                  path: '$imagePath-6.jpg',
                                ),
                                SpecialFood(
                                  width: width,
                                  labelFoodName: 'Spaghetti',
                                  priceTag: '200 Birr',
                                  path: '$imagePath-2.jpg',
                                ),
                                SpecialFood(
                                  width: width,
                                  labelFoodName: 'Spinach',
                                  priceTag: '400 Birr',
                                  path: '$imagePath-3.jpg',
                                ),
                                SpecialFood(
                                  width: width,
                                  labelFoodName: 'Beef Stew',
                                  priceTag: '500 Birr',
                                  path: '$imagePath-4.jpg',
                                ),
                                SpecialFood(
                                  width: width,
                                  labelFoodName: 'Beef Stew',
                                  priceTag: '600 Birr',
                                  path: '$imagePath-1.jpg',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    color: const Color.fromARGB(255, 16, 34, 54),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Ready to dive in?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              bottom: 15,
                            ),
                            child: Row(
                              children: [
                                OfferBox(
                                  width: width,
                                  icon: Icons.fastfood_outlined,
                                  headerText: 'Special offer',
                                  descriptionText:
                                      'Discover all our special offers that are  currently available',
                                  linkText: 'See more',
                                ),
                                OfferBox(
                                  width: width,
                                  icon: Icons.card_giftcard_outlined,
                                  headerText: 'Gift card',
                                  descriptionText:
                                      'Give the gift  of an incredible dining experiance',
                                  linkText: 'Discover gift cards',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Featured Restaurants',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'See more',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 251, 147, 91),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        restaurantsAsync.when(
                          data: (restaurants) {
                            if (restaurants.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  'No featured restaurants found.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: restaurants
                                    .take(5)
                                    .map(
                                      (restaurant) => FeaturedRestaurant(
                                        width: width,
                                        restaurant: restaurant,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: ShimmerList(count: 3, isHorizontal: true),
                          ),
                          error: (err, stack) => Center(
                            child: Column(
                              children: [
                                Text(
                                  'Failed to load restaurants',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                if (kDebugMode)
                                  Text(
                                    '$err',
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 10,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              //Carousel
              Container(
                height: width / 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(89, 59, 116, 134),
                      Color.fromARGB(42, 59, 116, 134),
                      Color.fromARGB(31, 59, 117, 134),
                      Color.fromARGB(63, 59, 116, 134),
                    ],
                  ),
                ),
                child: CarouselSlider(
                  options: CarouselOptions(
                    pauseAutoPlayInFiniteScroll: false,
                    pauseAutoPlayOnManualNavigate: false,
                    scrollPhysics: const PageScrollPhysics(),
                    viewportFraction: 0.5,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayCurve: Curves.linear,
                    height: width / 5,
                  ),
                  items:
                      [
                        Image.asset('assets/images/gallery-1.jpg'),
                        Image.asset('assets/images/gallery-2.jpg'),
                        Image.asset('assets/images/gallery-3.jpg'),
                        Image.asset('assets/images/gallery-4.jpg'),
                      ].map((el) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Row(
                                children: [
                                  Card(
                                    elevation: 5,
                                    clipBehavior: Clip.antiAlias,
                                    shape: const CircleBorder(
                                      side: BorderSide(width: 0),
                                    ),
                                    child: el,
                                  ),
                                  const SizedBox(width: 5),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '10K +',
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Booking done',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Restaurants',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      nearbyAsync.when(
                        data: (restaurants) {
                          if (restaurants.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'No restaurants available in this area.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            );
                          }
                          return Wrap(
                            children: restaurants
                                .map(
                                  (restaurant) =>
                                      RestaurantsList(restaurant: restaurant),
                                )
                                .toList(),
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: ShimmerList(count: 4, isHorizontal: false),
                        ),
                        error: (err, stack) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Connection Error: Check your internet',
                                  style: const TextStyle(color: Colors.red),
                                ),
                                if (kDebugMode)
                                  Text(
                                    '$err',
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OfferBox extends StatelessWidget {
  const OfferBox({
    super.key,
    required this.width,
    required this.icon,
    required this.headerText,
    required this.descriptionText,
    required this.linkText,
  });

  final double width;
  final String headerText;
  final IconData icon;
  final String descriptionText;
  final String linkText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width / 1.26,
      child: Card(
        elevation: 5,
        color: const Color.fromARGB(120, 14, 17, 24),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 8, 127, 145),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        headerText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.clear,
                    color: Color.fromARGB(255, 99, 213, 230),
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                descriptionText,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    linkText,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 163, 255, 241),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color.fromARGB(255, 99, 213, 230),
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeaturedRestaurant extends StatelessWidget {
  const FeaturedRestaurant({
    super.key,
    required this.width,
    required this.restaurant,
  });

  final double width;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final isNetworkImage =
        restaurant.images.isNotEmpty && restaurant.images[0].startsWith('http');
    final imagePath = restaurant.images.isNotEmpty
        ? restaurant.images[0]
        : 'assets/images/gallery-1.jpg';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/reservation_page',
        arguments: restaurant,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          height: 300,
          width: width / 1.6,
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
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isNetworkImage
                  ? Image.network(
                      imagePath,
                      width: width / 1.3,
                      height: 250 / 1.25,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: width / 1.3,
                        height: 250 / 1.25,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      width: width / 1.3,
                      height: 250 / 1.25,
                      fit: BoxFit.fill,
                    ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.utensils,
                          color: Color.fromARGB(255, 245, 154, 105),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          restaurant.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 228, 152, 111),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Average Price',
                    style: const TextStyle(
                      color: Color.fromARGB(235, 255, 255, 255),
                    ),
                    children: [
                      TextSpan(
                        text: '  ${restaurant.averagePrice} Br',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.pin_drop,
                    color: Color.fromARGB(230, 221, 148, 93),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    restaurant.address,
                    style: const TextStyle(
                      color: Color.fromARGB(235, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
