import 'package:flutter/material.dart';
import 'package:dine_ease/models/favourite_restaurant.dart';
import 'package:dine_ease/providers/favourite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dine_ease/components/favourite_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavouritePage extends ConsumerStatefulWidget {
  const FavouritePage({super.key});

  @override
  ConsumerState<FavouritePage> createState() => _FavouritePage();
}

class _FavouritePage extends ConsumerState<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    // final listProvider = Hive.box('favList').values.toList();
    final listProvider = ref.watch(favRestaurantProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: Colors.black,
            height: 50,
          ),
          Material(
            elevation: 10,
            child: Container(
              color: const Color.fromARGB(255, 54, 60, 66),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Favorites',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoriteList(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white70,
                        size: 26,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: listProvider.isEmpty
                ? const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'You don\'t have any favourite \nrestaurant yet!!',
                      style: TextStyle(
                          color: Color.fromARGB(255, 220, 227, 213),
                          fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: listProvider.length,
                    itemBuilder: (context, index) {
                      final list = listProvider.toList();

                      return ListTile(
                        leading: const Icon(
                          Icons.favorite_outline_outlined,
                          color: Color.fromARGB(255, 29, 144, 94),
                        ),
                        title: Text(
                          list[index].restaurantName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(list[index].createdTime.toString(),
                                style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            ref
                                .read(favRestaurantProvider.notifier)
                                .deleteRestaurant(list[index]);
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 26,
                            color: Color.fromARGB(255, 201, 32, 20),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Material(
            color: Colors.transparent,
            elevation: 10,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoriteList()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 29, 144, 94),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          'create a new list'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//PARTITION

class FavoriteList extends ConsumerStatefulWidget {
  const FavoriteList({super.key});

  @override
  ConsumerState<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends ConsumerState<FavoriteList> {
  TextEditingController controller = TextEditingController();

  late Box<FavouriteRestaurant> listBox;

  final FocusNode _focusNode = FocusNode();

  bool isFocused = false;

  void _openBox() async {
    print(Hive.isBoxOpen('favList'));
    if (!Hive.isBoxOpen('favList')) {
      listBox = await Hive.openBox<FavouriteRestaurant>('favList');
    } else {
      listBox = Hive.box<FavouriteRestaurant>('favList');
    }
  }

  @override
  void initState() {
    super.initState();
    _openBox();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? isFocused = true : isFocused = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (Hive.isBoxOpen('favList')) {
      listBox.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createdRestaurant = ref.watch(favRestaurantProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 54, 60, 66),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Create  a new list',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            focusNode: _focusNode,
            controller: controller,
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color.fromARGB(255, 29, 144, 94),
            decoration: const InputDecoration(
              hintText: 'Eg. My favorite restaurants in Bahirdar',
              helper: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Max. 50 characters',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),
              label: Text(
                'List Name',
                style: TextStyle(
                  color: Color.fromARGB(255, 29, 144, 94),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 29, 144, 94),
                  width: 0.7,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 29, 144, 94),
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          GestureDetector(
              onTap: () {
                final listName = controller.text;
                bool isListNameExists = createdRestaurant
                    .any((e) => e.restaurantName.trim() == listName);

                if (isListNameExists) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color.fromARGB(255, 87, 128, 128),
                      content:
                          Center(child: Text('List name already exists'))));
                } else if (listName.isNotEmpty) {
                  final newRestaurant = FavouriteRestaurant(
                    restaurantName: listName,
                    createdTime: DateTime.now(),
                  );

                  ref
                      .read(favRestaurantProvider.notifier)
                      .addRestaurant(newRestaurant);
                  listBox.add(newRestaurant);
                  controller.clear();

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color.fromARGB(255, 87, 128, 128),
                      content:
                          Center(child: Text('List name cannot be empty'))));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: isFocused
                        ? const Color.fromARGB(255, 29, 144, 94)
                        : const Color.fromARGB(255, 54, 60, 66),
                    borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'CREATE LIST',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
