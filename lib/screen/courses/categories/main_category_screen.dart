import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loksewa/screen/courses/model/courses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainCategoryScreen extends StatefulWidget {
  MainCategoryScreen({super.key});
  State<MainCategoryScreen> createState() => _MainCategoryScreen();
}

class _MainCategoryScreen extends State<MainCategoryScreen> {
  DatabaseReference reference = FirebaseDatabase.instance.ref();
  List<dynamic> courses = [];
  bool isFetched = false;

  String imageURL = "";

  Future<void> loadBack() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = preferences.getStringList("cb");
    if (data != null) {
      if(imageURL == "default"){
        imageURL ="";
      }else{
      imageURL = data[1];
      }
      setState(() {});
    } //if
  } //loadBack
  void fetch(String id,String type) {
    reference.child("courses").child(id).once().then((event) {
      courses = [];
      event.snapshot.children.forEach((element) {
        if(element.child("type").value == type){

        courses.add({
          "title": element.child("title").value,
          "key": element.child("key").value,
        });
        }//if
      }); //forEach

      setState(() {
        isFetched = true;
      });
    }); //then
  } //fetch

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> course = args["course"];
    List<int> categoriesId = args["course"]["categoriesMCQId"];
    int id = args["course"]["id"];
    String type = args["type"];
    fetch(id.toString(),type);
  }
  @override
  void initState() {
    super.initState();
    loadBack();
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> course = args["course"];
    List<int> categoriesId = args["course"]["categoriesMCQId"];
    int id = args["course"]["id"];
    String type = args["type"];
    int count = (MediaQuery.of(context).size.width / 200).round();

    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          child: Text("${course["title"]}"),
        ),
      ),
      body: SafeArea(
        child:isFetched? Container(
          decoration: BoxDecoration(
            image: imageURL.length > 2
                ? DecorationImage(
                    image: CachedNetworkImageProvider(imageURL), fit: BoxFit.cover)
                : null,
            // borderRadius: BorderRadius.circular(20),
          ),
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Categories (${type.toUpperCase()})",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "SubCategoryScreen",
                              arguments: {
                                "category":
                                    courses.elementAt(index)
                              });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            width: 180,
                            // decoration: BoxDecoration(color: Colors.white),
                            // padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset("assets/design_course/interFace1.png",
                                    fit: BoxFit.fitWidth,
                                    width: 100,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Flexible(
                                  child: Text(
                                      courses.elementAt(index)["title"],
                                      style: TextStyle(fontSize: 17),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(12),
                  // physics: NeverScrollableScrollPhysics(),
                ),
              )
            ],
          ),
        ): Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
