import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CourseCategoryChooserScreen extends StatefulWidget {
  int id;
  List<dynamic> keys;
  CourseCategoryChooserScreen(
      {super.key, required this.id, required this.keys});
  @override
  State<CourseCategoryChooserScreen> createState() => _TypeScreen();
}

class _TypeScreen extends State<CourseCategoryChooserScreen> {
  List<dynamic> categories = [];
  bool isFetched = false;
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref("/categories");

  void addCategoryInCourse(String key, String title, String type, int index) {
    FirebaseDatabase.instance
        .ref("/courses")
        .child(widget.id.toString())
        .child(key)
        .set({
      "key": key,
      "title": title,
      "type": type,
    }).then((value) {
      setState(() {
        categories.elementAt(index)["isAlready"] = true;
      });
    }).onError((error, stackTrace) {
      setState(() {
        categories.elementAt(index)["isAlready"] = true;
      });
    });
  } //addCategory

  void deleteCategoryInCourse(String key, int index) {
    FirebaseDatabase.instance
        .ref("/courses")
        .child(widget.id.toString())
        .child(key)
        .set({}).then((value) {
      setState(() {
        categories.elementAt(index)["isAlready"] = false;
      });
    }).onError((error, stackTrace) {
      
      setState(() {
        categories.elementAt(index)["isAlready"] = false;
      });
    });
  } //addCategory

  void fetchTypes() {
    reference.onValue.listen((DatabaseEvent event) {
      categories = [];
      bool isAlready = false;
      event.snapshot.children.forEach((element) {
        isAlready = false;
        widget.keys.forEach((ele) {
          if (ele["key"] == element.key.toString()) {
            isAlready = true;
          }
        }); //forEach
        categories.add({
          "title": element.child("title").value,
          "type": element.child("type").value,
          "key": element.key.toString(),
          "isAlready": isAlready,
        });
      });
      setState(() {
        isFetched = true;
      });
    });
  } //fetchTypes

  @override
  void initState() {
    super.initState();

    fetchTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose from below"),
      ),
      body: isFetched
          ? Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        if (categories.elementAt(index)["isAlready"] == false) {
                          addCategoryInCourse(
                              categories.elementAt(index)["key"],
                              categories.elementAt(index)["title"],
                              categories.elementAt(index)["type"],
                              index);
                        } //if
                        else {
                          deleteCategoryInCourse(
                              categories.elementAt(index)["key"], index);
                        } //selse
                      }, //onTap
                      child: Card(
                        color: categories.elementAt(index)["isAlready"] == true
                            ? Colors.purple.shade700
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(categories.elementAt(index)["title"]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  } //build
}//_TypeScreen