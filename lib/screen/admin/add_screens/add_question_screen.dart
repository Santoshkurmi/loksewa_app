import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';

class AddQuestionScreen extends StatefulWidget {
  String path, topicId;
  dynamic data;
  AddQuestionScreen(
      {super.key, required this.path, required this.topicId, this.data});
  State<AddQuestionScreen> createState() => _AddQuestionScreen();
}

class _AddQuestionScreen extends State<AddQuestionScreen> {
  String title = "",
      optionA = '',
      optionB = '',
      optionC = '',
      optionD = '',
      optionE = '',
      correctAns = '',
      imageURL = '',
      originalImageURL = '';
      bool isOptionE = false;
    
  DatabaseReference reference = FirebaseDatabase.instance.ref("/");
  String? email = FirebaseAuth.instance.currentUser?.email;
  final TextEditingController _titleC = TextEditingController();

  final TextEditingController _correctAnsC = TextEditingController();
  final TextEditingController _optionAC = TextEditingController();
  final TextEditingController _optionBC = TextEditingController();
  final TextEditingController _optionCC = TextEditingController();
  final TextEditingController _optionDC = TextEditingController();
  final TextEditingController _optionEC = TextEditingController();
  final TextEditingController _hintTextC = TextEditingController();
  bool isUploading = false;
  bool isImageUploadOption = false;
  
  bool isHintShow = false;
  String hintText ='';

  void addQuestion(String path, String topicId) async {
    if (path.length < 3 ||
        topicId.length < 3 ||
        title.length < 2 ||
        optionA.isEmpty ||
        optionB.isEmpty ||
        optionC.isEmpty ||
        optionD.isEmpty ||
        correctAns.isEmpty) return;
    if(isOptionE && optionE.isEmpty) return;

    setState(() {
      isUploading = true;
    });

    if (_questionImage != null && imageURL.length <5) {
      await uploadImage();
    }

    reference.child(path).push().set({
      "title": title,
      "correctAns": correctAns.trim().toUpperCase(),
      "optionA": optionA,
      "optionB": optionB,
      "optionC": optionC,
      "optionD": optionD,
      "optionE": isOptionE ? optionE :null,
      "topicId": topicId,
      "questionImage": imageURL.length < 6 ? null : imageURL,
      "email": email,
      "hint": hintText.trim().length>3 ? hintText:null,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
    });
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<bool> deleteImage() async {
    try {
      await FirebaseStorage.instance.refFromURL(originalImageURL).delete();
      showSnackBar("The old image is deleted successfully");
      return true;
    } catch (e) {
      showSnackBar(e.toString());
      return false;
    }
  }

  void editQuestion(String path, String topicId) async {
    if (path.length < 3 ||
        _titleC.text.length < 2 ||
        _optionAC.text.isEmpty ||
        _optionBC.text.isEmpty ||
        _optionCC.text.isEmpty ||
        _optionDC.text.isEmpty ||
        _correctAnsC.text.isEmpty) return;
    if(isOptionE && _optionEC.text.isEmpty) return;
    setState(() {
      isUploading = true;
    });

    bool isProceed = true;
    if (originalImageURL.length > 5 && imageURL.length < 5) {
      isProceed = await deleteImage();
      originalImageURL = "";
    } //if iamge

    if (_questionImage != null && imageURL.length < 5) {
      isProceed = await uploadImage();
      // isUploaded = true;
    }

    // if (isProceed == false) {
    //   showSnackBar("Cant proceed anymore from here");
    //   return;
    // }

    reference.child(path).child(widget.data["key"]).update({
      "title": _titleC.text,
      "correctAns": _correctAnsC.text.trim().toUpperCase(),
      "optionA": _optionAC.text,
      "optionB": _optionBC.text,
      "optionC": _optionCC.text,
      "optionD": _optionDC.text,
      "optionE": isOptionE ? optionE :null,
      "questionImage": imageURL.length < 5 ? null : imageURL,
      "hint": _hintTextC.text.trim().length>3 ? hintText:null,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
    });
  } //editQUestion

  @override
  void initState() {
    super.initState();
    if (widget.data == null) return;
    _titleC.text = widget.data["title"];
    _optionAC.text = widget.data["optionA"];
    _optionBC.text = widget.data["optionB"];
    _optionCC.text = widget.data["optionC"];
    _optionDC.text = widget.data["optionD"];
    optionE = widget.data["optionE"]?? '';
    _optionEC.text = optionE;
    if(optionE.isNotEmpty) isOptionE = true;
    _correctAnsC.text = widget.data["correctAns"];
    _hintTextC.text = widget.data["hint"] ?? '';
    hintText = _hintTextC.text;
    if(hintText.isNotEmpty){
      isHintShow = true;
    }
    imageURL = widget.data["questionImage"].toString();
    if (imageURL.length > 10) {
      isImageUploadOption = true;
      originalImageURL = imageURL;
    }
  }
  Uint8List? compressedImage;
  final picker = ImagePicker();
  File? _questionImage;
  bool isUploaded = false;
  void addImage() async {
    final filePicked = await picker.pickImage(source: ImageSource.gallery);
    setState(() async{
      if (filePicked != null) {
       var compressedImage =  await FlutterImageCompress.compressWithFile(filePicked.path,quality: 20);
        _questionImage = File(filePicked.path);
        imageURL = "";
      } //if
      else {
        _questionImage = null;
      }
    });
  }

  Future<bool> uploadImage() async {
    // if(_questionImage==null)return;
    final storage = FirebaseStorage.instance;
    try {
      final task = await storage
          .ref()
          .child("images")
          .child(DateTime.now().toString())
          .putFile(_questionImage as File);
      // setState(() {
      imageURL = await task.ref.getDownloadURL();
      showSnackBar("Image uploaded successfully");
      return true;
    } catch (msg) {
      showSnackBar(msg.toString());
      return false;
    }
    // storage.ref().child().delete();

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add question"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                setState(() {
                  isImageUploadOption = true;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.keyboard_option_key),
              onPressed: () {
                setState(() {
                  isOptionE = !isOptionE;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: () {
                setState(() {
                  isHintShow = true;
                  hintText = '';
                });
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleC,
                minLines: 2,
                maxLines: 50,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => title = value,
                decoration: InputDecoration(
                  labelText: 'title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isImageUploadOption
                  ? Container(
                      height: _questionImage == null && imageURL.length < 8
                          ? null
                          : 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          addImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          child: _questionImage == null && imageURL.length < 8
                              ? Text("Add Question Image")
                              : Stack(children: [
                                  ClipRRect(
                                    child: _questionImage != null
                                        ? PhotoView(
                                            imageProvider: FileImage(
                                                _questionImage as File),
                                            enablePanAlways: true,
                                            gestureDetectorBehavior:
                                                HitTestBehavior.translucent,
                                            tightMode: true,
                                            enableRotation: true,
                                            customSize: Size(300, 300),
                                          )
                                        : PhotoView(
                                            imageProvider:
                                                CachedNetworkImageProvider(
                                                    imageURL)),
                                  ),
                                  Positioned(
                                      top: 10,
                                      right: 10,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _questionImage = null;
                                              imageURL = "";
                                            });
                                          },
                                          icon: Icon(Icons.close)))
                                ]),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 20,
              ),
              compressedImage!=null?Image.memory(compressedImage as Uint8List):SizedBox(),
              TextField(
                // minLines: 1,
                controller: _optionAC,
                minLines: 1,
                maxLines: 40,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                onChanged: (value) => optionA = value,
                decoration: InputDecoration(
                  labelText: 'optionA',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.keyboard_option_key),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                minLines: 1,
                controller: _optionBC,
                maxLines: 40,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => optionB = value,
                decoration: InputDecoration(
                  labelText: 'optionB',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.keyboard_option_key),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                // minLines: 1,
                controller: _optionCC,
                minLines: 1,
                maxLines: 30,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => optionC = value,
                decoration: InputDecoration(
                  labelText: 'option C',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.keyboard_option_key),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                // minLines: 1,
                controller: _optionDC,
                minLines: 1,
                maxLines: 30,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => optionD = value,
                decoration: InputDecoration(
                  labelText: 'option D',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.keyboard_option_key),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isOptionE? TextField(
                // minLines: 1,
                controller: _optionEC,
                minLines: 1,
                maxLines: 30,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => optionE = value,
                decoration: InputDecoration(
                  labelText: 'option E',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.keyboard_option_key),
                ),
              ):SizedBox(),
              SizedBox(
                height: 20,
              ),
              TextField(
                // minLines: 1,
                controller: _correctAnsC,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => correctAns = value,
                decoration: InputDecoration(
                  labelText: 'correct ans',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.question_answer),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isHintShow ? TextField(
                minLines: 2,
                maxLines: 100,
                controller: _hintTextC,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => hintText = value,
                decoration: InputDecoration(
                  labelText: 'Hint',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.lightbulb),
                ),
              ):SizedBox(),
              SizedBox(
                height: 20,
              ),
              isUploading == false
                  ? MaterialButton(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () => {
                        widget.data == null
                            ? addQuestion(widget.path, widget.topicId)
                            : editQuestion(widget.path, widget.topicId)
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      color: Colors.purple.shade700,
                      elevation: 5.0,
                      child: Text(
                        "Add Question",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  } //
}
