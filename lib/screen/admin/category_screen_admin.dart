import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/add_screens/add_category_screen.dart';
import 'package:loksewa/screen/admin/model_admin/dummy_data.dart';
import 'package:loksewa/screen/admin/subcategory_screen_admin.dart';
import 'package:loksewa/screen/courses/model/courses.dart';

class CategoryScreenAdmin extends StatefulWidget {
  String type;
  CategoryScreenAdmin({super.key, required this.type});
  @override
  State<CategoryScreenAdmin> createState() => _TypeScreen();
}

class _TypeScreen extends State<CategoryScreenAdmin> {
  List<dynamic> categoriesList = [];
  bool isFetched = false;
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref("/categories");

  
  
  void deleteCurrentElement(dynamic element) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // icon: Icon(Icons.delete),
          title: Text("Are you sure to delete?"),
          content: Text(
            "You are going to delete category '${element['title']}'.\nAll the subCategory of this  category also get delted.",
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




  void fetchTypes(String type) {
    reference.orderByChild("type").equalTo(type).onValue.listen((event) {
      print("Changing value of " + isFetched.toString());
      categoriesList = [];
      event.snapshot.children.forEach((element) {
        // print("Downoa");

        categoriesList.add({
          "key": element.key,
          "title": element.child("title").value,
          "path": element.child("path").value,
        });
      });
      setState(() {
        isFetched = true;
      });
    }); //refereence
  } //fetchTypes

  @override
  void initState() {
    print(widget.type);
    super.initState();
    fetchTypes(widget.type);
  }

  @override
  void dispose() {
    super.dispose();
    print("Disposing value of " + isFetched.toString());
    isFetched = false;
  }

  // @override
  // void didChangeDependencies() {
  //   // Map<String, dynamic> args =
  //   //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  //   // String type = args["type"];
  //   // super.didChangeDependencies();
  //   // fetchTypes(type);
  // }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> args =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    // String type = args["type"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: isFetched
          ? Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListView.builder(
                itemCount: categoriesList.length,
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
                                            SubCategoryScreenAdmin(
                                              categoryKey: categoriesList.elementAt(index)["key"],
                                              path: categoriesList.elementAt(index)["path"],
                                              title: categoriesList.elementAt(index)["title"],
                                            ),
                                      ));
                                },
                                onLongPress: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return AddCategoryScreen(
                                        data: categoriesList.elementAt(index),
                                        type: widget.type,
                                      );
                                    },
                                  ));
                                },
                                child: ListTile(
                                  title: Text(categoriesList.elementAt(index)["title"]),
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
                                        builder: (context) => AddCategoryScreen(
                                          type: widget.type,
                                          data: categoriesList.elementAt(index),
                                        ),
                                      ));
                                } //1
                                else if (value == 2) {
                                  deleteCurrentElement(categoriesList.elementAt(index));
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
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddCategoryScreen(
                type: widget.type,
              );
            },
          )); //push
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  } //build
}//_TypeScreen