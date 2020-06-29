import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:testing/flutter_scan_bluetooth.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:testing/widget/rounded_button.dart';

//void main() => runApp(new MyApp1());

class MyApp1 extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  @override
  FlutterBlue flutterBlue = FlutterBlue.instance;
  double minDist = double.infinity;
  int noOfDev = 0;
  String minName = "";
  bool socialFailed = false;
  String status = "blue";
  Set<String> names = {};
  bool scanning = false;
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
//        appBar: new AppBar(
//          title: const Text('Plugin example app'),
//        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/scan_bg2.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Image.asset("images/$status.gif")),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.display1,
                    children: [
                      TextSpan(
                        text: " Safe? : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: socialFailed ? "No" : "Yes",
                        style: socialFailed
                            ? TextStyle(
                                color: Colors.red,
                                fontStyle: FontStyle.italic,
                              )
                            : TextStyle(
                                color: Colors.green,
                                fontStyle: FontStyle.italic,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.display1,
                    children: [
                      TextSpan(
                        text: " Trespassers : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "${names.length}",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.display1,
                    children: [
                      TextSpan(
                        text: " Min Dist : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: minDist.toStringAsFixed(4) + " m",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RoundedButton(
                      text: scanning ? 'Stop scan' : 'Start scan',
                      press: () async {
                        flutterBlue.startScan(timeout: Duration(seconds: 4));
                        setState(() {
                          scanning = true;
                        });
                        flutterBlue.scanResults.listen(
                          (results) {
                            // do something with scan results
                            noOfDev = 0;
                            minDist = double.infinity;
                            double dist = 0;
                            minName = "";
                            socialFailed = false;
                            status = "blue";
                            names.clear();
                            for (ScanResult r in results) {
                              debugPrint("name!!!: " + r.toString());
                              print('${r.device.name} found! rssi: ${r.rssi}');
                              names.add(r.device.name);
                              dist = pow(10, ((-69 - (r.rssi)) / (10 * 2)));
                              debugPrint("distance from the device $dist");
                              if (dist < minDist) {
                                minDist = dist;
                                minName = r.device.name;
                                debugPrint(
                                    "dist = $minDist \n $minName \n $socialFailed");
                                if (minDist < 1.86) {
                                  setState(() {
                                    socialFailed = true;
                                    debugPrint("red hua re");
                                    status = "red";
                                  });
                                }
                              }
                              // min dist, no of devices.
                            }
                            if (minName != "" || minDist != double.infinity) {
                              setState(() {
//                              Alert(
//                                context: context,
//                                title: "Name of device: $minName",
//                                desc:
//                                    "Distance: - $minDist \n You are socially failed? ${names.length}",
//                              ).show();
                              });
                            }
                            if (socialFailed != true) {
                              setState(() {
                                status = "green";
                              });
                            }
                            // if social true vibrate
                          },
                        );
                        flutterBlue.stopScan();
                        setState(() {
                          debugPrint("stoppedrekgbrejgb");
                          scanning = false;
                        });
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
