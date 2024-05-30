import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loksewa/screen/courses/model/courses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseIntroScreen extends StatefulWidget {
  CourseIntroScreen({super.key});

  @override
  State<CourseIntroScreen> createState() => _CourseIntroScreen();
}

class _CourseIntroScreen extends State<CourseIntroScreen> {
  String imageURL = "";

  Future<void> loadBack() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = preferences.getStringList("cib");
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
    loadBack();
  }
  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Map<String,dynamic> course = args["course"];
    int count = (MediaQuery.of(context).size.width / 200).round();

    return Scaffold(
      appBar: AppBar(
        title: Title(
          child: Text("${course["title"]}"),
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Stack(children: [
          Container(
          decoration: BoxDecoration(
            image: imageURL.length > 2
                ? DecorationImage(
                    image: CachedNetworkImageProvider(imageURL), fit: BoxFit.cover)
                : null,
            // borderRadius: BorderRadius.circular(20),
          ),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: GridView(
                        padding: EdgeInsets.all(12),
                        physics: NeverScrollableScrollPhysics(),
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: count,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10),
                        children: [
                          InkWell(
                            onTap: () {Navigator.pushNamed(context, "MainCategoryScreen",arguments: {"course":course,"type":"gk"});},
                            borderRadius: BorderRadius.circular(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: 180,
                                // decoration: BoxDecoration(color: Colors.white),
                                // padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          datas
                                              .elementAt(0)
                                              ["courses"]
                                              .elementAt(0)
                                              ["imagePath"],
                                          fit: BoxFit.fitWidth,
                                          // height: 150,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("GK (I)")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {Navigator.pushNamed(context, "MainCategoryScreen",arguments: {"course":course,"type":"iq"});},
                            borderRadius: BorderRadius.circular(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: 180,
                                // decoration: BoxDecoration(color: Colors.white),
                                // padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          datas
                                              .elementAt(0)
                                              ["courses"]
                                              .elementAt(0)
                                              ["imagePath"],
                                          fit: BoxFit.fitWidth,
                                          // height: 150,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("IQ (I)")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: 180,
                                // decoration: BoxDecoration(color: Colors.white),
                                // padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          datas
                                              .elementAt(0)
                                              ["courses"]
                                              .elementAt(0)
                                              ["imagePath"],
                                          fit: BoxFit.fitWidth,
                                          // height: 150,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Notes(I,II,III)")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: 180,
                                // decoration: BoxDecoration(color: Colors.white),
                                // padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          datas
                                              .elementAt(0)
                                              ["courses"]
                                              .elementAt(0)
                                              ["imagePath"],
                                          fit: BoxFit.fitWidth,
                                          // height: 150,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Mock Test")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: 180,
                                // decoration: BoxDecoration(color: Colors.white),
                                // padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          datas
                                              .elementAt(0)
                                              ["courses"]
                                              .elementAt(0)
                                              ["imagePath"],
                                          fit: BoxFit.fitWidth,
                                          // height: 150,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Exams")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: 180,
                                // decoration: BoxDecoration(color: Colors.white),
                                // padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          datas
                                              .elementAt(0)
                                              ["courses"]
                                              .elementAt(0)
                                              ["imagePath"],
                                          fit: BoxFit.fitWidth,
                                          // height: 150,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Favourites")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                onPressed: (){
                  Navigator.pushNamed(context, "SyallbusScreen");
                },
                color: Colors.purple.shade800,
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                child: Text("View Syallbus")),

            )),
        ]),
      ),
    );
  } //reutrn
}
