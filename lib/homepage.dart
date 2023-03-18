import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task/secondpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> colors = [];
  int? indexSelected;

  getColors() {
    for (int i = 0; i < 10; i++) {
      Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      colors.add(color);
    }
  }

  @override
  void initState() {
    getColors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: 10,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            indexSelected = index;
                          });
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: colors[index],
                            shape: BoxShape.circle,
                            border: indexSelected == index
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Spacer(),
          MaterialButton(
            onPressed: () {
              if (indexSelected == null) {
                var snackBar = SnackBar(
                  content: Text('Select at least one color'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondPage(
                              color: colors[indexSelected!],
                            )));
              }
            },
            color: Colors.black45,
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    ));
  }
}
