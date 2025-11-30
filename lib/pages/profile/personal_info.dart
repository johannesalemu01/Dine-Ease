import 'dart:ui';

import 'package:flutter/material.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personl Information',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 10, 24, 39),
      ),
      backgroundColor: const Color.fromARGB(255, 10, 24, 39),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 255, 132, 0),
              radius: 30,
              child: Text('J',
                  style: TextStyle(color: Colors.white, fontSize: 32)),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Johannes Alemu',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const Form(
                    child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          showCursor: false,
                          decoration: InputDecoration(
                            suffix: ExpansionTile(
                              collapsedIconColor:
                                  Color.fromARGB(255, 29, 144, 94),
                              backgroundColor: Color.fromARGB(255, 51, 68, 56),
                              title: Text(''),
                              iconColor: Color.fromARGB(255, 29, 144, 94),
                              children: [
                                Text(
                                  'Mr.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Mrs',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            label: Text(
                              'Title',
                              style: TextStyle(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 29, 144, 94),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 29, 144, 94),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white70, height: 0.7),
                        cursorColor: Colors.white60,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                          label: Text(
                            'first name',
                            style: TextStyle(color: Colors.white54),
                          ),
                          // hintText: 'johannes',
                          // hintStyle: TextStyle(color: Colors.white60),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white60),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 29, 144, 94),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white70, height: 0.7),
                        cursorColor: Colors.white60,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                          label: Text(
                            'last name',
                            style: TextStyle(color: Colors.white54),
                          ),
                          // hintText: 'Alemu',
                          // hintStyle: TextStyle(color: Colors.white60),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white60),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 29, 144, 94),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white70, height: 0.7),
                        cursorColor: Colors.white60,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                          label: Text(
                            'email ',
                            style: TextStyle(color: Colors.white54),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white60),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 29, 144, 94),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        style: TextStyle(color: Colors.white70, height: 0.7),
                        cursorColor: Colors.white60,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                          labelText: 'Date of birth',
                          hintStyle: TextStyle(color: Colors.white60),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white60),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 29, 144, 94),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
