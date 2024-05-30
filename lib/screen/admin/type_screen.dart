import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/add_screens/add_type_screen.dart';
import 'package:loksewa/screen/admin/category_screen_admin.dart';
import 'package:loksewa/screen/admin/course_category_adder_screen.dart';
import 'package:loksewa/screen/admin/model_admin/dummy_data.dart';

class TypeScreen extends StatefulWidget {
  TypeScreen({super.key});
  @override
  State<TypeScreen> createState() => _TypeScreen();
}

class _TypeScreen extends State<TypeScreen> {
  List<dynamic> types = [];
  bool isFetched = false;
  final DatabaseReference reference = FirebaseDatabase.instance.ref("/types");

  void fetchTypes() {
    reference.onValue.listen((DatabaseEvent event) {
      types = [];
      event.snapshot.children.forEach((element) {
        types.add({
          "title": element.child("title").value,
          "type": element.child("type").value,
          "key": element.key,
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

  void deleteCurrentElement(dynamic element) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // icon: Icon(Icons.delete),
          title: Text("Are you sure to delete?"),
          content: Text(
            "You are going to delete type '${element['title']}'",
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if(element["key"].toString().length<5){return;}
                  reference
                      .child(element["key"])
                      .set(null)
                      .then((value) {})
                      .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted ${element['title']} successfully")));
                        setState(() {
                        });
                      })
                      .catchError((onError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("It may be deleted not sure")));
                        setState(() {
                        });
                      });
                },
                child: Text("Delete")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
          ],
        );
      },
    );
  } //delteCurrentElement

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Types"),
      ),
      body: isFetched
          ? Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListView.builder(
                itemCount: types.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      // color:index ==0? Colors.purple.shade700: null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryScreenAdmin(
                                                type: types
                                                    .elementAt(index)["type"]),
                                      ));
                                },
                                onLongPress: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return AddTypeScreen(
                                        data: types.elementAt(index),
                                      );
                                    },
                                  ));
                                },
                                child: ListTile(
                                  title: Text(types.elementAt(index)["title"]),
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text("Edit"),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Text("Delete"),
                                  )
                                ];
                              },
                              onSelected: (value) {
                                if (value == 1) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddTypeScreen(
                                          data: types.elementAt(index),
                                        ),
                                      ));
                                } //1
                                else if (value == 2) {
                                  deleteCurrentElement(types.elementAt(index));
                                }
                              },
                            )
                          ],
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "AddTypeScreen");
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  } //build
}//_TypeScreen