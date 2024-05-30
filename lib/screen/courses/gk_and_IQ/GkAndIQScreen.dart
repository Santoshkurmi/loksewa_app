import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:loksewa/screen/customization/change_ui_background.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> loadJsonFile(String path) async {
  return await rootBundle.loadString("assets/datas/$path.json");
}

class GkAndIQScreen extends StatefulWidget {
  @override
  State<GkAndIQScreen> createState() => _GkAndIQScreen();
}

enum TtsState { playing, stopped, paused, continued }

class _GkAndIQScreen extends State<GkAndIQScreen> {
  List<dynamic> datas = [];
  bool isFetched = false;
  DatabaseReference reference = FirebaseDatabase.instance.ref();

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1;
  double pitch = 1;
  double rate = 0.4;
  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;
  bool get isPaused => ttsState == TtsState.paused;
  bool get isContinued => ttsState == TtsState.continued;

  bool get isIOS => false;
  bool get isAndroid => true;
  bool get isWindows => false;
  bool get isWeb => false;
  bool isLoaded = false;

  void fetch(String path, String topicId) {
    if (isLoaded) return;
    reference
        .child(path)
        .orderByChild("topicId")
        .equalTo(topicId)
        .once()
        .then((value) {
      datas = [];
      value.snapshot.children.forEach((element) {
        datas.add({
          "questionTitle": element.child("title").value,
          "correctAnswer": element.child("correctAns").value,
          "optionA": element.child("optionA").value,
          "optionB": element.child("optionB").value,
          "optionC": element.child("optionC").value,
          "optionD": element.child("optionD").value,
          "optionE": element.child("optionE").value,
          "hint": element.child("hint").value,
          "questionImage": element.child("questionImage").value,
        });
      }); //forEach
      isLoaded = true;

      datas.forEach((element) {
        questionsOnly.add(
            "$element['questionTitle'] $element['optionA'] $element['optionC'] $element['optionD']");
      });
      setState(() {
        isFetched = true;
        originalData = [...datas];
      });
    }); //get
  } //fetchk

  @override
  void didChangeDependencies() {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> category = args["subCategory"];
    String path = category["path"];
    String topicId = category["key"];
    loadBack();
    fetch(path, topicId);
  }

  @override
  void initState() {
    super.initState();
    // loadBack();
    initTts();
    // _speak();
  }

  String textToSearch = "";
  List<String> questionsOnly = [];
  List<dynamic> originalData = [];
  var isSearch = false;
  var searchController = FocusNode();
  int currentPlayingIndex = -1;

  Color textColor = Colors.white, borderColor = Colors.grey.shade700;
  int opacity = 255;
  String image = "";
  bool enableCardBackground = false;

  String imageURL = "";
  int currentClicked = -1;

  Future<void> loadBack() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = preferences.getStringList("qb");
    List<String>? fore = preferences.getStringList("qf");
    if (fore != null) {
      image = fore[1];
      if (image == "default") {
        enableCardBackground = false;
      } else {
        enableCardBackground = true;
      }
      textColor = int.parse(fore[3]) == 0 ? Colors.white : Colors.black;
      opacity = int.parse(fore[4]);
    } //
    if (data != null) {
      if (imageURL == "default") {
        imageURL = "";
      } else {
        imageURL = data[1];
      }
      setState(() {});
    } //if
  } //loadBack

  void setCardBackground(int index) {
    switch (index) {
      case -1:
        enableCardBackground = false;
        textColor = Colors.white;
        opacity = 255;
        setState(() {});
        break;
      case 1:
        enableCardBackground = true;
        opacity = 0;
        image =
            "https://wallpapers.com/images/high/dark-theme-gold-metallic-dice-kpt8hg5s2ap71dln.webp";
        borderColor = Colors.grey.shade700;
        textColor = Colors.white;
        setState(() {});
        break;
      case 2:
        enableCardBackground = true;
        opacity = 0;
        image =
            "https://wallpapers.com/images/high/beautiful-dark-night-with-shooting-stars-kc0lgr6rplku557j.webp";
        borderColor = Colors.grey.shade700;
        textColor = Colors.white;
        setState(() {});
        break;
      case 3:
        enableCardBackground = true;
        opacity = 0;
        image =
            "https://wallpapers.com/images/high/raining-blue-glitters-beautiful-dark-background-5arz3mai7o1ccaf7.webp";
        borderColor = Colors.grey.shade700;
        textColor = Colors.white;
        setState(() {});
        break;
      case 4:
        enableCardBackground = true;
        opacity = 0;
        image =
            "https://wallpapers.com/images/high/beautiful-dark-outer-space-and-planet-hjd2ezzinznjbl40.webp";
        borderColor = Colors.grey.shade700;
        textColor = Colors.white;
        setState(() {});
        break;
      case 5:
        enableCardBackground = true;
        opacity = 0;
        image =
            "https://wallpapers.com/images/high/white-crumpled-paper-atmosphere-aj108cz2e6i5grku.webp";
        textColor = Colors.black;
        // borderColor = Colors.transparent;
        setState(() {});
        break;

      case 6:
        enableCardBackground = true;
        opacity = 0;
        image =
            "https://wallpapers.com/images/high/soft-pink-bas5mopxd0w84noy.webp";
        textColor = Colors.black;
        // borderColor = Colors.transparent;
        setState(() {});
        break;
    } //swtich
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Map<String, dynamic> category = args["subCategory"];
    String path = category["path"];
    String topicId = category["key"];
    print("**************************$path");
    // List<int> subCategoryIds = category["subCategoriesId"];
    return Scaffold(
      appBar: isSearch == false
          ? AppBar(
              title: Text("${category['title']}"),
              actions: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    _stop();
                    setState(() {
                      isSearch = true;
                    });
                    searchController.requestFocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.search),
                  ),
                ),
                PopupMenuButton(
                  onSelected: (index) {
                    print(index);
                    if (index == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeUIBackground(id: 0),
                          ));
                    } //
                    else if (index == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeUIBackground(id: 1),
                          ));
                    } //
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 1,
                        child: Text("Change Background"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Change Foreground"),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text("Start reading mode"),
                      ),
                      PopupMenuItem(
                        value: 4,
                        child: Row(
                          children: [
                            Text("Shows answers"),
                            Checkbox(
                              value: false,
                              onChanged: (state) {},
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            )
          : AppBar(
              title: TextField(
                // minLines: 1,
                focusNode: searchController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.text,

                // onChanged: (value) => type = value,
                onChanged: (value) {
                  datas = [];
                  textToSearch = value;
                  if (textToSearch.isEmpty) {
                    datas = [...originalData];
                    setState(() {});
                    return;
                  }
                  if (textToSearch.length < 2) return;
                  _stop();
                  var found = extractTop(
                    query: textToSearch,
                    choices: questionsOnly,
                    cutoff: 30,
                    limit: 30,
                  ).map((e) => e.index).forEach((element) {
                    datas.add(originalData[element]);
                  });

                  setState(() {});

                  // print(found);
                },
                decoration: InputDecoration(
                  labelText: 'Enter to search',
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () {
                        isSearch = false;
                        datas = [...originalData];
                      },
                    ),
                    icon: Icon(Icons.close),
                  ),

                  // border: OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(10))),
                  // prefixIcon: Icon(Icons.title),
                ),
              ),
              leading: null,
            ),
      body: SafeArea(
        child: isFetched
            ? Container(
                decoration: BoxDecoration(
                  image: imageURL.length > 2
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(imageURL),
                          fit: BoxFit.cover)
                      : null,
                  // borderRadius: BorderRadius.circular(20),
                ),
                // color: Colors.blue,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: datas.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 30),
                            child: Container(
                              decoration: enableCardBackground
                                  ? BoxDecoration(
                                      // color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 3, color: borderColor),
                                      image: DecorationImage(

                                          // image: NetworkImage("https://wallpapers.com/images/high/beautiful-dark-dim-stage-iuohr36krwjyx0rr.webp"),
                                          // image: NetworkImage("https://wallpapers.com/images/high/dark-theme-light-bulb-close-up-2520czvwrywwcx3s.webp"),
                                          image:
                                              CachedNetworkImageProvider(image),
                                          fit: BoxFit.cover),
                                    )
                                  : null,
                              child: Card(
                                // color: Color.,
                                color: enableCardBackground
                                    ? Color.fromARGB(opacity, 0, 0, 0)
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              child: Text(
                                                "${index + 1}. ${datas[index]["questionTitle"]}",
                                                // overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: textColor),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: () async {
                                              if (ttsState ==
                                                  TtsState.stopped) {
                                                _speak(index);
                                              } //stopped
                                              else if (ttsState ==
                                                  TtsState.playing) {
                                                if (index ==
                                                    currentPlayingIndex)
                                                  _stop();
                                                else {
                                                  await _stop();
                                                  _speak(index);
                                                }
                                              } //playing
                                            },
                                            child: index == currentPlayingIndex
                                                ? Lottie.asset(
                                                    "assets/lottie/sound.json")
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Icon(
                                                        Icons.keyboard_voice),
                                                  ),
                                          )
                                        ],
                                      ),
                                      if (datas[index]["questionImage"] != null)
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
                                                            datas[index][
                                                                "questionImage"]))),
                                          ),
                                        ),
                                      // Image.asset("assets/design_course/interFace1.png",height: 150,fit: BoxFit.contain,)
                                      Divider(
                                        thickness: 1,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            // ignore: prefer_interpolation_to_compose_strings
                                            if (datas[index]["color" +
                                                    datas[index]
                                                        ["correctAnswer"]] !=
                                                null) {
                                              return;
                                            }
                                            currentClicked = index;
                                            if (datas[index]["correctAnswer"] ==
                                                "A") {
                                              setState(() {
                                                datas[index]["colorA"] =
                                                    Colors.green.shade500;
                                              });
                                            } //if
                                            else {
                                              setState(() {
                                                datas[index]["colorA"] =
                                                    Colors.red.shade500;
                                              });
                                            } //if
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: datas[index]["colorA"],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                        "a.  ${datas[index]["optionA"]}",
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                    ),
                                                  ),
                                                  // Lottie.asset("assets/lottie/loved.json",height: 40),
                                                  // Lottie.asset("assets/lottie/sad.json",height: 35),
                                                  // datas[index]["colorA"]==Colors.green.shade500 ?  Lottie.asset("assets/lottie/loved.json",height: 40): datas[index]["colorA"]!=null? Lottie.asset("assets/lottie/sad.json",height: 35):null,
                                                  if (currentClicked == index &&
                                                      datas[index]["colorA"] !=
                                                          null)
                                                    if (datas[index]
                                                            ["colorA"] ==
                                                        Colors.green.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/loved.json",
                                                          height: 40)
                                                    else if (datas[index]
                                                            ["colorA"] ==
                                                        Colors.red.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/sad.json",
                                                          height: 35)
                                                ],
                                              ),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      InkWell(
                                          onTap: () {
                                            if (datas[index]["color" +
                                                    datas[index]
                                                        ["correctAnswer"]] !=
                                                null) {
                                              return;
                                            }
                                            currentClicked = index;
                                            if (datas[index]["correctAnswer"] ==
                                                "B") {
                                              setState(() {
                                                datas[index]["colorB"] =
                                                    Colors.green.shade500;
                                              });
                                            } //if
                                            else {
                                              setState(() {
                                                datas[index]["colorB"] =
                                                    Colors.red.shade500;
                                              });
                                            } //if
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: datas[index]["colorB"],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                        "b.  ${datas[index]["optionB"]}",
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                    ),
                                                  ),
                                                  // Lottie.asset("assets/lottie/loved.json",height: 40),
                                                  // Lottie.asset("assets/lottie/sad.json",height: 35),
                                                  // datas[index]["colorA"]==Colors.green.shade500 ?  Lottie.asset("assets/lottie/loved.json",height: 40): datas[index]["colorA"]!=null? Lottie.asset("assets/lottie/sad.json",height: 35):null,
                                                  if (currentClicked == index &&
                                                      datas[index]["colorB"] !=
                                                          null)
                                                    if (datas[index]
                                                            ["colorB"] ==
                                                        Colors.green.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/loved.json",
                                                          height: 40)
                                                    else if (datas[index]
                                                            ["colorB"] ==
                                                        Colors.red.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/sad.json",
                                                          height: 35)
                                                ],
                                              ),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      InkWell(
                                          onTap: () {
                                            if (datas[index]["color" +
                                                    datas[index]
                                                        ["correctAnswer"]] !=
                                                null) {
                                              return;
                                            }
                                            currentClicked = index;
                                            if (datas[index]["correctAnswer"] ==
                                                "C") {
                                              setState(() {
                                                datas[index]["colorC"] =
                                                    Colors.green.shade500;
                                              });
                                            } //if
                                            else {
                                              setState(() {
                                                datas[index]["colorC"] =
                                                    Colors.red.shade500;
                                              });
                                            } //if
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: datas[index]["colorC"],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                        "c.  ${datas[index]["optionC"]}",
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                    ),
                                                  ),
                                                  // Lottie.asset("assets/lottie/loved.json",height: 40),
                                                  // Lottie.asset("assets/lottie/sad.json",height: 35),
                                                  // datas[index]["colorA"]==Colors.green.shade500 ?  Lottie.asset("assets/lottie/loved.json",height: 40): datas[index]["colorA"]!=null? Lottie.asset("assets/lottie/sad.json",height: 35):null,
                                                  if (currentClicked == index &&
                                                      datas[index]["colorC"] !=
                                                          null)
                                                    if (datas[index]
                                                            ["colorC"] ==
                                                        Colors.green.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/loved.json",
                                                          height: 40)
                                                    else if (datas[index]
                                                            ["colorC"] ==
                                                        Colors.red.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/sad.json",
                                                          height: 35)
                                                ],
                                              ),
                                            ),
                                          )),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      InkWell(
                                          onTap: () {
                                            if (datas[index]["color" +
                                                    datas[index]
                                                        ["correctAnswer"]] !=
                                                null) {
                                              return;
                                            }
                                            currentClicked = index;
                                            if (datas[index]["correctAnswer"] ==
                                                "D") {
                                              setState(() {
                                                datas[index]["colorD"] =
                                                    Colors.green.shade500;
                                              });
                                            } //if
                                            else {
                                              setState(() {
                                                datas[index]["colorD"] =
                                                    Colors.red.shade500;
                                              });
                                            } //if
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: datas[index]["colorD"],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                        "d.  ${datas[index]["optionD"]}",
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                    ),
                                                  ),
                                                  // Lottie.asset("assets/lottie/loved.json",height: 40),
                                                  // Lottie.asset("assets/lottie/sad.json",height: 35),
                                                  // datas[index]["colorA"]==Colors.green.shade500 ?  Lottie.asset("assets/lottie/loved.json",height: 40): datas[index]["colorA"]!=null? Lottie.asset("assets/lottie/sad.json",height: 35):null,
                                                  if (currentClicked == index &&
                                                      datas[index]["colorD"] !=
                                                          null)
                                                    if (datas[index]
                                                            ["colorD"] ==
                                                        Colors.green.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/loved.json",
                                                          height: 40)
                                                    else if (datas[index]
                                                            ["colorD"] ==
                                                        Colors.red.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/sad.json",
                                                          height: 35)
                                                ],
                                              ),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),

                                    datas[index]["optionE"]!=null?  InkWell(
                                          onTap: () {
                                            if (datas[index]["color" +
                                                    datas[index]
                                                        ["correctAnswer"]] !=
                                                null) {
                                              return;
                                            }
                                            currentClicked = index;
                                            if (datas[index]["correctAnswer"] ==
                                                "E") {
                                              setState(() {
                                                datas[index]["colorE"] =
                                                    Colors.green.shade500;
                                              });
                                            } //if
                                            else {
                                              setState(() {
                                                datas[index]["colorE"] =
                                                    Colors.red.shade500;
                                              });
                                            } //if
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: datas[index]["colorE"],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                        "e.  ${datas[index]["optionE"]}",
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                    ),
                                                  ),
                                                  // Lottie.asset("assets/lottie/loved.json",height: 40),
                                                  // Lottie.asset("assets/lottie/sad.json",height: 35),
                                                  // datas[index]["colorA"]==Colors.green.shade500 ?  Lottie.asset("assets/lottie/loved.json",height: 40): datas[index]["colorA"]!=null? Lottie.asset("assets/lottie/sad.json",height: 35):null,
                                                  if (currentClicked == index &&
                                                      datas[index]["colorE"] !=
                                                          null)
                                                    if (datas[index]
                                                            ["colorE"] ==
                                                        Colors.green.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/loved.json",
                                                          height: 40)
                                                    else if (datas[index]
                                                            ["colorE"] ==
                                                        Colors.red.shade500)
                                                      Lottie.asset(
                                                          "assets/lottie/sad.json",
                                                          height: 35)
                                                ],
                                              ),
                                            ),
                                          )):SizedBox(),

                                      datas.elementAt(index)["hint"] != null &&
                                              datas.elementAt(index)["color" +
                                                      datas.elementAt(index)[
                                                          "correctAnswer"]] !=
                                                  null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    // Divider(height: 1,),
                                                    Text(
                                                      "Hint:",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: textColor),
                                                    ),
                                                    Text(
                                                        datas.elementAt(
                                                            index)["hint"],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: textColor))
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox()
                                      // RadioListTile(value: "Kath",title: Text("Kath"), groupValue: selectedValue, onChanged: (String? value){setValue(value);})
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      // bottomNavigationBar: NavigationBar(destinations: [
      //   NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: "GK"),
      //   NavigationDestination(icon: Icon(Icons.precision_manufacturing), label: "IQ"),
      // ],),
    );
  } //build

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future<void> _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future<void> _getDefaultVoice() async {
    // var lang = await flutterTts.getLanguages;
    await flutterTts.setLanguage("ne-NP");
    // var voice = await flutterTts.getVoices;
    // var data = await flutterTts.setVoice({"name": "ne-np-x-nep-network", "locale": "ne-NP"});
    // print(data);
    // flutterTts.getVoices;
    // voice.forEach((e) {
    //   if (e["locale"].contains("NP")) print(e);
    // });
    // print(lang);
  }

  Future<void> _speak(int index) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    // if (text.isNotEmpty) {
    String text = datas[index]["questionTitle"] +
        ", option A, " +
        datas[index]["optionA"] +
        ", B, " +
        datas[index]["optionB"] +
        ", C, " +
        datas[index]["optionC"] +
        ", D, " +
        datas[index]["optionD"];
    currentPlayingIndex = index;
    await flutterTts.speak(text);
    // setState(() {
    currentPlayingIndex = -1;
    // });
    // }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
    currentPlayingIndex = -1;
  }

  Future<void> _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  dynamic initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      // _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        // print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        // print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  void _parseJSON(String path) async {
    String jsonString = await loadJsonFile(path);
    print("Loaded something ");
    // Decode the JSON string into a Map<String, dynamic> using json.decode()
    List<dynamic> datas = json.decode(jsonString);
    setState(() {
      this.datas = datas;
    });
    // You can now access the data like any other Map
  }
}//_GkClass