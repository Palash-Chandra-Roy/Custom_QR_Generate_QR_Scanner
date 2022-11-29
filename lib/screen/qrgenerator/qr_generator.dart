import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math' as math;
import 'package:screenshot/screenshot.dart';

import '../bottomwidget/bottom_widget.dart';
import '../customdrawer/custom_drawer.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({Key? key}) : super(key: key);

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final _fastCtrl = TextEditingController();
  final _secondCtrl = TextEditingController();
  final _thirdCtrl = TextEditingController();
  final _fourCtrl = TextEditingController();
  final _fiveCtrl = TextEditingController();
  final _sixCtrl = TextEditingController();
  final _sevenCtrl = TextEditingController();
  final _eightCtrl = TextEditingController();
  final _nineCtrl = TextEditingController();

  ScreenshotController screenshotController = ScreenshotController();
  bool isVisible = false;

  String qrCode="";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(
            backgroundColor: Colors.white70,
            title: Text(
              "WBMDTCL e- Challan",
              style: TextStyle(color: Colors.black, fontFamily: "Sofia"),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            elevation: 0.0,
          ),
          drawer:CustomDrawer(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Screenshot(
                  controller:screenshotController,
                  child: QrImage(
                    data:qrCode,
                    size:math.min(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height) /
                        1.3,
                    backgroundColor:Colors.white70,
                    //backgroundColor: Color.fromARGB(179, 255, 255, 255),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Visibility(
                  visible: isVisible,
                  child: Align(
                      alignment: Alignment.center,
                      child: ButtonWidget(
                          text: "Take a Photo",
                          onClicked: () async {
                            final image = await screenshotController.capture();
                            if (image == null) return;
                            await saveImage(image);
                          })),
                ),
                SizedBox(
                  height: 10,
                ),
                buildTextField(context: context, controller:_fastCtrl),
                buildTextField(context: context, controller: _secondCtrl),
                buildTextField(context: context, controller: _thirdCtrl),
                buildTextField(context: context, controller: _fourCtrl),
                buildTextField(context: context, controller: _fiveCtrl),
                buildTextField(context: context, controller: _sixCtrl),
                buildTextField(context: context, controller: _sevenCtrl),
                buildTextField(context: context, controller: _eightCtrl),
                buildTextField(context: context, controller: _nineCtrl),

                ElevatedButton(onPressed: (){

                  Map<String,dynamic> data={
                    "e-Challan Issue Date":_fastCtrl.text,
                    "Validity Till":_secondCtrl.text,
                    "Quantity of Sand":_thirdCtrl.text,
                    "Vehicle No":_fourCtrl.text,
                    "Sand Block Id":_fiveCtrl.text,
                    "River":_sixCtrl.text,
                    "Sand Block District":_sevenCtrl.text,
                    "Lessee":_eightCtrl.text,
                    "Destination District":_nineCtrl.text,

                  };
                  setState((){
                    qrCode=jsonEncode(data);

                  });
                }, child:Text("QR Generate")),
              ],
            ),
          )),
    );
  }

  saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll(".", "-")
        .replaceAll(":", "-");
    final name = "Screensort_${_fastCtrl.text+_secondCtrl.text+_thirdCtrl.text+_fourCtrl.text+_fiveCtrl.text+_sixCtrl.text+_sevenCtrl.text+_eightCtrl.text+_nineCtrl.text}";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    return result;
  }

  buildTextField({required BuildContext context,required TextEditingController controller}) {
    return Container(
        padding: EdgeInsets.all(19),
        child: TextField(
            controller:controller,
            style: TextStyle(
                color: Colors.black, fontSize: 18),
            decoration: InputDecoration(
              hintText: "Enter Data",
              hintStyle: TextStyle(
                  color: Colors.black
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
        ));
  }
}
