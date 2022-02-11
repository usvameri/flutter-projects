import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'dart:math';

import '../db/todo_db.dart';

class CategoryCard extends StatefulWidget {
  final dynamic data;

  const CategoryCard({Key? key, required this.data}) : super(key: key);
  @override
  _CategoryCard createState() => _CategoryCard();
}

class _CategoryCard extends State<CategoryCard> {
  // const CategoriesScroller();
  List<Widget> cards = [];
  var bgColors = [
    Colors.orange.shade400,
    Colors.blue,
    Colors.red.shade400,
    Colors.brown.shade400,
    Colors.green.shade400
  ];
  final _random = Random();
  var selectedItem = 0;
  Future deleteTodo() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    TodoDatabase.instance.delete(this.selectedItem);

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItem = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          );
        }).whenComplete(() {
      setState(() {
        selectedItem = 0;
      });
    });
  }

  List<Widget> createCards(data) {
    List<dynamic> responseList = data;
    List<Widget> listItems = [];

    responseList.forEach((element) {
      listItems.add(
        GestureDetector(
          onLongPress: () {
            setState(() {
              this.selectedItem = element.id;
              deleteTodo();
            });
          },
          child: Container(
            width: 150,
            margin: EdgeInsets.only(right: 20),
            height: 150,
            decoration: BoxDecoration(
                color: bgColors[_random.nextInt(bgColors.length)],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    element.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    element.description,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(children: createCards(widget.data)),
      ),
    );
  }
}
