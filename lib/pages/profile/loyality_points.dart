import 'package:flutter/material.dart';
import 'package:dine_ease/pages/search_page.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoyalityPoint extends StatefulWidget {
  const LoyalityPoint({super.key});

  @override
  State<LoyalityPoint> createState() => _LoyalityPointState();
}

class _LoyalityPointState extends State<LoyalityPoint> {
  @override
  Widget build(BuildContext context) {
    int? points;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.4,
        backgroundColor: Colors.black,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
              color: Colors.white,
            ),
            const SizedBox(
              width: 30,
            ),
            const Text(
              'Points',
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
        actions: const [
          Icon(
            Icons.info_outline_rounded,
            color: Color.fromARGB(255, 155, 225, 141),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/home_background.png',
                height: 130,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 20,
                left: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your current Points are',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      child: Text(
                        '${points ?? 0}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Explore your point benefits',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HowDiscountsWork()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(70, 44, 26, 26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.3, color: Colors.white)),
                    child: Card(
                      color: const Color.fromARGB(210, 22, 20, 34),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 187, 106, 0),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(Icons.takeout_dining,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                const Text(
                                  'Delicious discounts',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white70,
                                  size: 30,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RichText(
                              text: const TextSpan(
                                text: 'Earn',
                                style: TextStyle(color: Colors.white60),
                                children: [
                                  TextSpan(
                                    text: ' 100 Points ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white70),
                                  ),
                                  TextSpan(
                                    text:
                                        ' per reservation and unlock big savings at',
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                  TextSpan(
                                    text: ' 50+',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white70),
                                  ),
                                  TextSpan(
                                    text: ' spots',
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Br.0',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Br.50',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Br.120',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Container(
                              height: 7,
                              decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'points',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '1000',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '2000',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 26, 95, 30),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(
                    Icons.menu_open,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'No recent Points activity',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'Start earning loyality Points by booking your first restaurant or inviting friends to TheMesob ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      side: WidgetStatePropertyAll(
                          BorderSide(color: Color.fromARGB(48, 255, 255, 255))),
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(185, 61, 36, 27))),
                  onPressed: () {},
                  child: const Text(
                    'Learn more',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HowDiscountsWork extends StatelessWidget {
  const HowDiscountsWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(77, 0, 14, 41),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              color: const Color.fromARGB(255, 31, 43, 43),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/illustrations/howitworks.svg',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    const Text(
                      'How it works',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          text: 'Use your points to',
                          style: TextStyle(color: Colors.white70, height: 1.5),
                          children: [
                            TextSpan(
                                text: ' get tasty discounts',
                                style: TextStyle(color: Colors.white)),
                            TextSpan(
                                text:
                                    ' when you book at any of our Point partner restaurants.'),
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white70, height: 1.5),
                        text: 'Simply choose one of ',
                        children: [
                          TextSpan(
                              text: '50+ restaurants',
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                            text:
                                ' that accept points, pick a quality points time slot, and your loyality discounts',
                          ),
                          TextSpan(
                            text:
                                ' will be applied automatically to your final bill ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'at the restaurant.',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchPage())),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 2, 126, 122),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Explore restaurants',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.4,
                          ),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Not now',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
