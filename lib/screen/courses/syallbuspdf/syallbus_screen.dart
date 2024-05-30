import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class SyallbusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Syallbus"),
        ),
        body: SafeArea(
          child: PdfView(
            controller: PdfController(
              document: PdfDocument.openAsset("assets/course/nasu/first.pdf"),
              viewportFraction: 1
            ),
          scrollDirection: Axis.vertical,
          ),
          ),
        );
  } //build
}//class