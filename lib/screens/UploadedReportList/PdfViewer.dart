import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GlobalWidget/customAppBars.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({Key? key}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int pages = 0;
  int indexPage = 0;

  late File file;
  var pdfLink;
  var pdfLoaded = false;
  dynamic arguments = Get.arguments;
  @override
  void initState() {
    getPdfLink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBarWithBack(context, showBack: true),
      body: Container(
        height: h,
        width: w,
        child: pdfLoaded
            ? getPdfViewer(context)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<void> getPdfLink() async {
    try {
      pdfLink = arguments[0];
      print("================> pdf link $pdfLink");
      // final url = "$pdfLink";
      // file = await PDFApi.loadNetwork(url);
      //
      // print("================> pdf link $file ");
      setState(() {
        pdfLoaded = true;
      });
    } catch (e) {
      print("=====================error on view pdf $e");
    }
  }

  getPdfViewer(BuildContext context) {
    return SfPdfViewer.network(pdfLink);
  }
}
