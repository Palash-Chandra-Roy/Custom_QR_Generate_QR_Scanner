import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../bottomwidget/bottom_widget.dart';
import '../customdrawer/custom_drawer.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  String qrCode ="";
  void _launchURL() async {
    if (await launchUrlString(qrCode)) ;
  }

  bool isVisivle = false;
  Map<String,dynamic> _data={};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Text(
            "WBMDTCL e-Challan",
            style: TextStyle(color: Colors.black, fontFamily: "Sofia"),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0.0,
        ),
        drawer: CustomDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("e-Challan Validity Expired",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),),
                Spacer(),
                SizedBox(height: 10,),
                Text("e-Challan Issue Date"),
                Text("${_data["e-Challan Issue Date"]==null?"No Data":this._data["e-Challan Issue Date"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["e-Challan Issue Date"]==null
                          ?Colors.red
                          :Colors.green),
                ),
                Spacer(),
                Text("Validity Till"),
                Text("${_data["Validity Till"]==null?"No Data":this._data["Validity Till"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["Validity Till"]==null
                          ?Colors.red
                          :Colors.green
                  ),),
                Spacer(),
                Text("Quantity of Sand"),
                Text("${_data["Quantity of Sand"]==null?"No Data":this._data["Quantity of Sand"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["Quantity of Sand"]==null
                          ?Colors.red
                          :Colors.green
                  ),),
                Spacer(),
                Text("Vehicle No"),
                Text("${_data["Vehicle No"]==null?"No Data":this._data["Vehicle No"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["Vehicle No"]==null
                          ?Colors.red
                          :Colors.green),),
                Spacer(),
                Text("Sand Block Id"),
                Text("${_data["Sand Block Id"]==null?"No Data":this._data["Sand Block Id"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["Sand Block Id"]==null
                          ?Colors.red
                          :Colors.green ),),
                Spacer(),
                Text("River"),
                Text("${_data["River"]==null?"No Data":this._data["River"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["River"]==null
                          ?Colors.red
                          :Colors.green ),),
                Spacer(),
                Text("Sand Block District"),
                Text("${_data["Sand Block District"]==null?"No Data":this._data["Sand Block District"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["Sand Block District"]==null
                          ?Colors.red
                          :Colors.green
                  ),),
                Spacer(),
                Text("Lessee"),
                Text("${_data["Lessee"]==null?"No Data":this._data["Lessee"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["Lessee"]==null
                          ?Colors.red
                          :Colors.green),),
                Spacer(),
                Text("Destination District"),
                Text("${_data["Destination District"]==null?"No Data":this._data["Destination District"].toString()}",
                  style:TextStyle(
                      fontSize: 16,
                      color: _data["Destination District"]==null
                          ?Colors.red
                          :Colors.green
                  ),
                ),

                Visibility(
                  visible: isVisivle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButtonWidget(
                          text: "Copy",
                          icon: Icons.copy,
                          onClicked: () {
                            final data = ClipboardData(text: qrCode);
                            Clipboard.setData(data);
                          }),
                      IconButtonWidget(
                          text: "Open",
                          icon: Icons.open_in_browser,
                          onClicked: () => _launchURL()),
                      IconButtonWidget(
                          text: "Share",
                          icon: Icons.share,
                          onClicked: () {
                            if (qrCode.isNotEmpty) {
                              Share.share(qrCode);
                            } else {
                              return null;
                            }
                          })
                    ],
                  ),
                ),
                Spacer(),
                Center(
                  child: ElevatedButton(
                      onPressed: (){
                        scanQrCode();
                      },
                      child: Text("Scan QR Code ",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanQrCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        "#5fa693",
        "cancel",
        true,
        ScanMode.QR,
      );

      if (!mounted) return;
      setState(() {
        isVisivle = true;
        this.qrCode = qrCode.isEmpty
            ? ''
            : qrCode == "-1"
            ? ''
            : qrCode;

        print("string data : ${ this.qrCode}");

        this._data=jsonDecode(this.qrCode.toString());

        print("map data : ${this._data}");
      });
    } on PlatformException {
      qrCode = "Failed to get QR";
    }
  }
}
