import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCheatQuestionsScreen extends StatefulWidget {
  String path;
  String topicId;
  AddCheatQuestionsScreen({super.key,required this.path,required this.topicId});
  State<AddCheatQuestionsScreen> createState() => _AddCategoryScreen();
}

class _AddCategoryScreen extends State<AddCheatQuestionsScreen> {
  String fileName = "", topicId = "";
  DatabaseReference reference = FirebaseDatabase.instance.ref("/");


  Future<List<dynamic>> parseJSON() async {
  String jsonString = await rootBundle.loadString("assets/datas/gk subj-${fileName} I.json");
  List<dynamic> datas = json.decode(jsonString);
  List<dynamic> normalizedData = [];
    
  datas.forEach((element) {
      if(element["topicID"].toString() == topicId) {
    normalizedData.add({
      "title":element["questionTitle"],
      "optionA":element["optionA"],
      "optionB":element["optionB"],
      "optionC":element["optionC"],
      "optionD":element["optionD"],
      "correctAns":element["correctAnswer"],
      "explanation": element["explanation"],
      "topicId":widget.topicId
    });
      }//if
  });//forEach


  return normalizedData;
}//parseeJson

  Future<void> addCategory(String path,String topicId) async {
      List<dynamic> questions =await  parseJSON();
      List<Future<void>> futures=[];
      int counter =0;

      questions.forEach((element){

      futures.add(Future(()async {
        await reference.child(path).push().set(element);
        counter = counter +1;
      }));

      });//forEach
    
      await Future.wait(futures);
      print("******total lenght is ${questions.length}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Added ${counter}/${questions.length}"))
      );
      // Navigator.pop(context);
      
  }
  


  @override
  Widget build(BuildContext context) {
    // String type = widget.type;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                // minLines: 1,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                onChanged: (value) => fileName = value,
                decoration: InputDecoration(
                  labelText: 'fileName',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                // minLines: 1,
                cursorColor: Colors.black,
                // controller: _titleController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => topicId = value,
                decoration: InputDecoration(
                  labelText: 'topic Id',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                padding: EdgeInsets.only(top: 18, bottom: 18),
                minWidth: MediaQuery.of(context).size.width,
                onPressed: ()async{ addCategory(widget.path,widget.topicId);},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                color: Colors.black,
                elevation: 5.0,
                child: Text(
                  "Add cheat questions",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } //
}
