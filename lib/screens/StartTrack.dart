import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

var main = Colors.white;

class StartTrack extends StatefulWidget {
  @override
  _StartTrackState createState() => _StartTrackState();
}

class _StartTrackState extends State<StartTrack> {
  // var _loca = 'NotSelected';
  // var _bus = 'NotSelected';
  var _loca, _bus;
  bool stopt = false;
  bool c = false;
  var colora = Colors.indigo[900], colorb = Colors.indigo[300];
  bool a = false;
  bool started = false;
  var myLocation;
  var Add = 'Address';
  double lat = 0, lng = 0;
  TextEditingController _phone = TextEditingController();

  getUserLocation() async {
    //call this async method from whereever you need

    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    // currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    print(myLocation.latitude);
    print(myLocation.longitude);
    setState(() {
      lat = myLocation.latitude;
      lng = myLocation.longitude;
    });
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    setState(() {
      Add =
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}';
    });
    return first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          'UCoE',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: main,
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Circle(Colors.blue, Colors.red, stopt ? 'Stop' : 'Track'),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.indigo[200],
                  border: Border.all(
                    color: Colors.indigo[400],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: DropdownButton<String>(
                      underline: Container(),
                      focusColor: Colors.white,
                      value: _loca,
                      //elevation: 5,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>[
                        'Mira Road',
                        'Vasai',
                        'Thane',
                        'Borivali',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Select Location",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _loca = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: DropdownButton<String>(
                      underline: Container(),
                      focusColor: Colors.white,
                      value: _bus,
                      //elevation: 5,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>[
                        'bus1',
                        'bus2',
                        'bus3',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Select Bus",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _bus = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 0,
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.indigo[200],
                  border: Border.all(color: Colors.indigo[400], width: 0.9),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _phone,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Phone Number',
                    hintStyle: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    print('clicked');
                    if (_loca != null && _bus != null && _phone.text != ''
                        // _phone.text != null
                        ) {
                      //code for start tracking

                      updateData();
                      func();
                      stopt = false;
                      a = true;
                    } else {
                      //code for Not Selected bus
                      print(_phone.text);
                      print(_loca);
                      print(_bus);
                      DialogBox2(context);
                    }
                  },
                  child: Buttonn(
                      // Colors.green[900], Colors.green[300],
                      colora,
                      colorb,
                      'Start Tracking'),
                ),
                MaterialButton(
                  onPressed: () {
                    if (a) {
                      stopt = true;
                      print('stop clicked');
                      a = false;
                    }
                  },
                  child: Buttonn(
                      Colors.red[900], Colors.red[300], 'Stop Tracking'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  updateData() {
    const fiveSeconds = const Duration(seconds: 5);
    // _fetchData() is your function to fetch data
    setState(() {
      started = !started;
    });
    Timer.periodic(fiveSeconds, (Timer t) async {
      if (a) {
        getUserLocation();

        await FirebaseFirestore.instance
            .collection(_loca + _bus)
            .doc('location')
            // .collection('Tracking')
            // .doc('location')
            // .collection(_loca)
            // .doc(_bus)
            .set({
          'latitude': lat,
          'longitude': lng,
          'Address': Add,
          'Phone': _phone.text,
        }).catchError((e) {
          print(e.toString());
          Fluttertoast.showToast(
              msg: 'Error Sending Data',
              timeInSecForIosWeb: 2,
              textColor: Colors.white,
              backgroundColor: Colors.indigo[900]);
        });

        //     await FirebaseFirestore.instance
        //         .collection('MiraRoad')
        //         .doc('location')
        //         .set({
        //       'latitude': lat,
        //       'longitude': lng,
        //       'Address': Add
        //     }).catchError((e) {
        //       print(e);
        //     });
      } else {
        t.cancel();
      }
    });
  }

  func() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      print('running');

      if (stopt) {
        t.cancel();
        setState(() {
          colora = Colors.indigo[900];
          colorb = Colors.indigo[300];
        });
        print('time stopyyayayayayayayayayayayayayayy');
      } else {
        if (c) {
          setState(() {
            c = false;
            colora = Color(0xffd09693);
            colorb = Color(0xffc71d6f);
          });
        } else {
          setState(() {
            c = true;
            colora = Color(0xffc71d6f);
            colorb = Color(0xffd09693);
          });
        }
      }
    });
  }

  Widget Buttonn(colora, colorb, text) {
    return Container(
        height: 100,
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
                spreadRadius: 0.8,
                color: Colors.grey,
                offset: Offset(0.7, 0.9),
                blurRadius: 0.8)
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Colors.indigo[900],
              // Colors.indigo[300],
              colora,
              colorb
            ],
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ));
  }

  Widget Circle(color1, color2, text) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colora,
        boxShadow: [
          BoxShadow(
              spreadRadius: 4.0,
              color: Colors.blue[100],
              offset: Offset(5.9, 9.0),
              blurRadius: 0.8)
        ],
      ),
      child: Center(
        child: Container(
          height: 280,
          width: 280,
          decoration: BoxDecoration(
            color: main,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorb,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2.0,
                      color: Colors.grey,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 0.8)
                ],
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: main,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.green[600],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void DialogBox2(context) {
    var baseDialog = AlertDialog(
      title: new Text("Warning"),
      content: Container(
        child: Text('Select All Fields Properly'),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.indigo[900],
          child: new Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }
}
