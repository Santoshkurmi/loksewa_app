import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_math_fork/tex.dart';
import 'package:loksewa/screen/admin/add_screens/add_cheat_questions_screen.dart';
import 'package:loksewa/screen/admin/add_screens/add_question_screen.dart';
import 'package:loksewa/screen/admin/model_admin/dummy_data.dart';
import 'package:photo_view/photo_view.dart';

class QuestionScreenAdmin extends StatefulWidget {
  String path, topicId, title;
  QuestionScreenAdmin(
      {super.key,
      required this.path,
      required this.topicId,
      required this.title});
  @override
  State<QuestionScreenAdmin> createState() => _TypeScreen();
}

class _TypeScreen extends State<QuestionScreenAdmin> {
  List<dynamic> questions = [];
  bool isFetched = false;
  DatabaseReference reference = FirebaseDatabase.instance.ref();

  void fetchTypes(String topicId, String path) {
    // if(topicId.isEmpty && path.length<2) return;
    reference
        .child(path)
        .orderByChild("topicId")
        .equalTo(topicId)
        .onValue
        .listen((event) {
      questions = [];
      event.snapshot.children.toList().reversed.forEach((element) {
        // print("Downoa");

        questions.add({
          "title": element.child("title").value,
          "correctAns": element.child("correctAns").value,
          "optionA": element.child("optionA").value,
          "optionB": element.child("optionB").value,
          "optionC": element.child("optionC").value,
          "optionD": element.child("optionD").value,
          "optionE": element.child("optionE").value,
          "hint": element.child("hint").value,
          "email": element.child("email").value,
          "questionImage": element.child("questionImage").value,
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
    fetchTypes(widget.topicId, widget.path);
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<bool> deleteImage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
      showSnackBar("The old image is deleted successfully");
      return true;
    } catch (e) {
      showSnackBar(e.toString());
      return false;
    }
  }
  void deleteCurrentElement(dynamic element) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // icon: Icon(Icons.delete),
          title: Text("Are you sure to delete?"),
          content: Text(
            "You are going to delete question '${element['title']}'.\n",
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (element["key"].toString().length < 5) {
                    return;
                  }
                
                  if(element["questionImage"].toString().length>5){
                    deleteImage(element["questionImage"]);
                  }//delete the image too

                  reference
                      .child(widget.path)
                      .child(element["key"])
                      .set(null)
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Deleted ${element['title']} successfully")));
                    setState(() {});
                  }).catchError((onError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("It may be deleted not sure")));
                    setState(() {});
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
var currentQues;
  @override
  Widget build(BuildContext context) {
    // List subcategoriesList  =[];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: SafeArea(
        child: isFetched
            ? Container(
                // color: Colors.blue,
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    currentQues = questions[index];
                    questions[index][
                            "color${questions.elementAt(index)['correctAns']}"] =
                        Colors.green.shade500;
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onLongPress: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return AddQuestionScreen(
                                            path: widget.path,
                                            topicId: widget.topicId,
                                            data: questions.elementAt(index),
                                          );
                                        }));
                                      },
                                      child: Text(
                                        "${index + 1}. ${questions.elementAt(index)["title"]}",
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    questions[index]["email"]
                                        .toString()
                                        .substring(0, 5),
                                    style: TextStyle(fontSize: 10),
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
                                              builder: (context) =>
                                                  AddQuestionScreen(
                                            path: widget.path,
                                            topicId: widget.topicId,
                                            data: questions.elementAt(index),
                                              ),
                                            ));
                                      } //1
                                      else if (value == 2) {
                                        deleteCurrentElement(
                                            questions.elementAt(index));
                                      }
                                    },
                                  )
                                ],
                              ),
                              // TeXView(
                              //   child: TeXViewContainer(
                              //     child: TeXViewDocument("Hello worldfjslfjsdlfjslfjsldjslfjsl")
                              //   )
                              //   ),
                              if (questions[index]["questionImage"] != null)
                                ClipRRect(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: SizedBox(
                                        // decoration: BoxDecoration(
                                        //   // border: Border.all(width: 1,color: Colors.white),
                                        //   borderRadius: BorderRadius.circular(15)
                                        // ),
                                        height: 200,
                                        child: PhotoView(
                                            imageProvider:
                                                CachedNetworkImageProvider(
                                                    questions[index]
                                                        ["questionImage"]))),
                                  ),
                                ),
                              // Image.asset("assets/design_course/interFace1.png",height: 150,fit: BoxFit.contain,)
                              Divider(
                                thickness: 1,
                              ),
                              InkWell(
                                  onTap: () {
                                    if (questions
                                            .elementAt(index)["correctAns"] ==
                                        "A") {
                                      setState(() {
                                        questions[index]["colorA"] =
                                            Colors.green.shade500;
                                      });
                                    } //if
                                    else {
                                      setState(() {
                                        questions[index]["colorA"] =
                                            Colors.red.shade500;
                                      });
                                    } //if
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: questions[index]["colorA"],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      // title: Text(
                                      //   "a.  ${questions[index]["optionA"]}",
                                      // ),
                              title:currentQues['optionA'].length>2&& currentQues["optionA"].substring(0,2)=="ee"? Math.tex("a.\\;\\;${currentQues['optionA'].substring(2)}",textStyle: TextStyle(fontSize: 18)) :Text("a . ${currentQues['optionA']}"),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),

                              InkWell(
                                  onTap: () {
                                    if (questions
                                            .elementAt(index)["correctAns"] ==
                                        "B") {
                                      setState(() {
                                        questions[index]["colorB"] =
                                            Colors.green.shade500;
                                      });
                                    } //if
                                    else {
                                      setState(() {
                                        questions[index]["colorB"] =
                                            Colors.red.shade500;
                                      });
                                    } //if
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: questions[index]["colorB"],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                              title:currentQues['optionB'].length>2&& currentQues["optionB"].substring(0,2)=="ee"? Math.tex("b.\\;\\;${currentQues['optionB'].substring(2)}",textStyle: TextStyle(fontSize: 18)) :Text("b . ${currentQues['optionB']}"),
                                      // title: Text(
                                      //   "b.  ${questions[index]["optionB"]}",
                                      // ),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),

                              InkWell(
                                  onTap: () {
                                    if (questions
                                            .elementAt(index)["correctAns"] ==
                                        "C") {
                                      setState(() {
                                        questions[index]["colorC"] =
                                            Colors.green.shade500;
                                      });
                                    } //if
                                    else {
                                      setState(() {
                                        questions[index]["colorC"] =
                                            Colors.red.shade500;
                                      });
                                    } //if
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: questions[index]["colorC"],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                              title:currentQues['optionC'].length>2&& currentQues["optionC"].substring(0,2)=="ee"? Math.tex("c.\\;\\;${currentQues['optionC'].substring(2)}",textStyle: TextStyle(fontSize: 18)) :Text("c . ${currentQues['optionC']}"),
                                      // title: Text(
                                      //   "c.  ${questions[index]["optionC"]}",
                                      // ),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),

                              InkWell(
                                  onTap: () {
                                    if (questions
                                            .elementAt(index)["correctAns"] ==
                                        "D") {
                                      setState(() {
                                        questions[index]["colorD"] =
                                            Colors.green.shade500;
                                      });
                                    } //if
                                    else {
                                      setState(() {
                                        questions[index]["colorD"] =
                                            Colors.red.shade500;
                                      });
                                    } //if
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: questions[index]["colorD"],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                              title:currentQues['optionD'].length>2&& currentQues["optionD"].substring(0,2)=="ee"? Math.tex("d.\\;\\;${currentQues['optionD'].substring(2)}",textStyle: TextStyle(fontSize: 18)) :Text("d . ${currentQues['optionD']}"),
                                      // title: Text(
                                      //   "d.  ${questions[index]["optionD"]}",
                                      // ),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),

                             questions.elementAt(index)["optionE"]!=null? InkWell(
                                  onTap: () {
                                    if (questions
                                            .elementAt(index)["correctAns"] ==
                                        "E") {
                                      setState(() {
                                        questions[index]["colorE"] =
                                            Colors.green.shade500;
                                      });
                                    } //if
                                    else {
                                      setState(() {
                                        questions[index]["colorE"] =
                                            Colors.red.shade500;
                                      });
                                    } //if
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: questions[index]["colorE"],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                              title:currentQues['optionE'].length>2&& currentQues["optionE"].substring(0,2)=="ee"? Math.tex("e.\\;\\;${currentQues['optionE'].substring(2)}",textStyle: TextStyle(fontSize: 18)) :Text("e . ${currentQues['optionE']}"),
                                      // title: Text(
                                      //   "e.  ${questions[index]["optionE"]}",
                                      // ),
                                    ),
                                  )):SizedBox(),
                              SizedBox(
                                height: 10,
                              ),
                        
                             questions.elementAt(index)["hint"]!=null ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white,width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Divider(height: 1,),
                                      Text("Hint:",style: TextStyle(fontSize: 20),),
                                      Text(questions.elementAt(index)["hint"],style: TextStyle(fontSize: 17),)
                                    ],
                                  ),
                                ),
                              ): SizedBox()

                              // RadioListTile(value: "Kath",title: Text("Kath"), groupValue: selectedValue, onChanged: (String? value){setValue(value);})
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddQuestionScreen(
                  path: widget.path, topicId: widget.topicId);
              // return AddCheatQuestionsScreen(
              //     path: widget.path, topicId: widget.topicId);
            },
          ));
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  } //build
}//_TypeScreen