import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/add_screens/add_sub_category_screen.dart';
import 'package:loksewa/screen/admin/questions_screen_screen.dart';
import 'package:loksewa/screen/courses/model/courses.dart';

class SubCategoryScreenAdmin extends StatefulWidget {
  String categoryKey, path,title;
  SubCategoryScreenAdmin(
      {super.key, required this.path, required this.categoryKey,required this.title});
  @override
  State<SubCategoryScreenAdmin> createState() => _TypeScreen();
}

class _TypeScreen extends State<SubCategoryScreenAdmin> {
  DatabaseReference reference = FirebaseDatabase.instance.ref("/categories");
  List<dynamic> subcategoriesList = [];
  bool isFetched = false;

  void fetchTypes(String parentKey) {
    if (parentKey.isEmpty) return;
    reference.child(parentKey).child("subCategories").onValue.listen((event) {
      subcategoriesList = [];
      event.snapshot.children.forEach((element) {
        // print("Downoa");

        subcategoriesList.add({
          "title": element.child("title").value,
          "key": element.key.toString(),
        });
      });
      setState(() {
        isFetched = true;
      });
    }); //refereence
  } //fetchTypes

  @override
  void initState() {
    super.initState();
    fetchTypes(widget.categoryKey);
  }

  void deleteCurrentElement(dynamic element) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // icon: Icon(Icons.delete),
          title: Text("Are you sure to delete?"),
          content: Text(
            "You are going to delete subCategory '${element['title']}'.\n",
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if(element["key"].toString().length<5){return;}
                  reference
                      .child(widget.categoryKey)
                      .child("subCategories")
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
  @override
  Widget build(BuildContext context) {
    // Map<String,dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    // List<dynamic> subcategoriesList = args["category"]["subCategories"] ?? [];
    // String parentKey = args["category"]["key"];
    // String path = args["category"]["path"];
    // List subcategoriesList  =[];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: isFetched
          ? Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListView.builder(
                itemCount: subcategoriesList.length,
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
                                            QuestionScreenAdmin(
                                              path: widget.path,
                                              topicId: subcategoriesList.elementAt(index)["key"],
                                              title: subcategoriesList.elementAt(index)["title"],
                                            ),
                                      ));
                                },
                                onLongPress: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return AddSubCategoryScreen(
                                          parentKey: widget.categoryKey,
                                          data: subcategoriesList.elementAt(index),
                                      );
                                    },
                                  ));
                                },
                                child: ListTile(
                                  title: Text(subcategoriesList.elementAt(index)["title"]),
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
                                        builder: (context) => AddSubCategoryScreen(
                                          parentKey: widget.categoryKey,
                                          data: subcategoriesList.elementAt(index),
                                        ),
                                      ));
                                } //1
                                else if (value == 2) {
                                  deleteCurrentElement(subcategoriesList.elementAt(index));
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
          // Navigator.pushNamed(context, "AddSubCategoryScreen",arguments: {"parentKey":widget.categoryKey});

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddSubCategoryScreen(parentKey: widget.categoryKey);
          }));
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  } //build
}//_TypeScreen