import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferFriend extends StatelessWidget {
  const ReferFriend({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: '8723432cd'.toUpperCase());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(
                left: 30,
                top: 50,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            'assets/images/illustrations/refer_friends3.jpeg',
            height: 350,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Column(
              children: [
                const Text(
                  textAlign: TextAlign.center,
                  'Share your code with a friend and claim 500 points as a reward 🔥🔥',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: controller,
                  // TextEditingController(text: '8723432cd'.toUpperCase()),
                  readOnly: true,
                  showCursor: false,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.white60),
                    labelText: 'Your code',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 29, 144, 94)),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 144, 94), width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        const snackBar = SnackBar(
                            content: Text('Text copied to clipboard! '));
                        Clipboard.setData(
                                ClipboardData(text: (controller.text)))
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar,
                            snackBarAnimationStyle: AnimationStyle(
                              curve: Curves.bounceInOut,
                              duration: const Duration(milliseconds: 600),
                              reverseCurve: Curves.bounceInOut,
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                            ),
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.copy_all,
                      ),
                      color: const Color.fromARGB(255, 29, 144, 94),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  'Your friend will earn 500 points as a rewared when they use your code for their first booking.',
                  style: TextStyle(color: Color.fromARGB(224, 255, 255, 255)),
                ),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color.fromARGB(255, 42, 158, 144)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'SHARE CODE',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
