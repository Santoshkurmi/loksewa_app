import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loksewa/screen/courses/model/courses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryScreen extends StatefulWidget{
  @override
  State<SubCategoryScreen> createState()=> _SubCategoryScreen();
}

class _SubCategoryScreen extends State<SubCategoryScreen> {

    DatabaseReference reference = FirebaseDatabase.instance.ref("/categories");
    String? path = "";
    List<dynamic> subCategoryIds = [];
    bool isFetched = false;

  String imageURL = "";

  Future<void> loadBack() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = preferences.getStringList("scb");
    if (data != null) {
      if(imageURL == "default"){
        imageURL ="";
      }else{
      imageURL = data[1];
      }
      setState(() {});
    } //if
  } //loadBack
  void fetch(String id){
    print(id);
      reference.child(id).once().then((value)  {
          subCategoryIds = [];
      
          path = value.snapshot.child("path").value as String; 
          value.snapshot.child("subCategories").children.forEach((element) {
            subCategoryIds.add({
              "path":path,
              "title":element.child("title").value,
              "key":element.key.toString()
            }); 
          });
      setState(() {
       isFetched = true; 
      });
      });
  }//fetch
  

  @override 
    void didChangeDependencies() {
    super.didChangeDependencies();
    var args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Map<String,dynamic> category = args["category"];
    String categoryId = category["key"];
    fetch(categoryId.toString());
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
    Map<String,dynamic> category = args["category"];
    String categoryId = category["key"];
    String categoryTitle = category["title"];
    int count = (MediaQuery.of(context).size.width / 200).round();

    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          child: Text("${categoryTitle}"),
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
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "SubCategories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:subCategoryIds.length ,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "GkAndIQScreen",
                              arguments: {"subCategory": subCategoryIds.elementAt(index)});
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/design_course/interFace1.png",
                                  fit: BoxFit.fitWidth,
                                  width: 100,
                                  // height: 150,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                    subCategoryIds.elementAt(index)["title"],
                                        style: TextStyle(fontSize: 17),
                                    ),
                              ),
                            ],
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
        ): Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
