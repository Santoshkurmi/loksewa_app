import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/courses/model/courses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseScreen extends StatefulWidget {
  CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreen();
}

class _CourseScreen extends State<CourseScreen> {
  String imageURL = "";

  Future<void> loadBack() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = preferences.getStringList("hb");
    if (data != null) {
      if(imageURL == "default"){
        imageURL ="";
      }else{
      imageURL = data[1];
      }
      setState(() {});
    } //if
  } //loadBack

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadBack();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            image: imageURL.length > 2
                ? DecorationImage(
                    image: CachedNetworkImageProvider(imageURL), fit: BoxFit.cover)
                : null,
            // borderRadius: BorderRadius.circular(20),
          ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(6),
              child: Column(
                children: buildCategoryList(),
              ),
            )
          ],
        ),
      ),
    );
  } //widet

  List<Widget> buildCategoryList() {
    List<Widget> lists = [];

    for (int categoriesIndex = 0;
        categoriesIndex < datas.length;
        categoriesIndex++) {
      lists.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              datas.elementAt(categoriesIndex)["title"],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 170,
            child: ListView.builder(
              itemCount: datas.elementAt(categoriesIndex)["courses"].length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.pushNamed(context, "CourseIntroScreen",
                          arguments: {
                            "course": datas
                                .elementAt(categoriesIndex)["courses"]
                                .elementAt(index)
                          });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SizedBox(
                          width: 140,
                          // decoration: BoxDecoration(color: Colors.white),
                          // padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset(
                                    datas
                                        .elementAt(categoriesIndex)["courses"]
                                        .elementAt(index)["imagePath"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(datas
                                    .elementAt(categoriesIndex)["courses"]
                                    .elementAt(index)["title"]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      )); //add
    } //for
    return lists;
  }
}//class