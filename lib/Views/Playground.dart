import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PlayGround extends StatefulWidget {
  @override
  _PlayGroundState createState() => _PlayGroundState();
}

class _PlayGroundState extends State<PlayGround> {

  Future sID;

  List<String> arrStringID = List<String>();
  List<String> arrStringName = List<String>();
  List<String> arrTotalShots = List<String>();
  List<String> arrTotalTime = List<String>();




  @override
  void initState() {
    super.initState();

    sID = _getID();





  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: sID,
        builder: (context,snapshot){

          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
            //updateData(sID);
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color> (Colors.red),
                          strokeWidth: 5.0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                print('Error Here: ${snapshot.error}');
                return Text('Error Here: ${snapshot.error}');
              } else {
                print("Got into widget");
                return Column(
                    children: <Widget> [
                      Flexible(
                        child:
                        new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: arrStringID.length,
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                                child:Column(
                                  children: <Widget>[
                                    Card(
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: <Widget>[

                                          Text(arrStringName[index],style: TextStyle(fontSize: 30, color: Colors.black)),
                                          Spacer(),
                                          Text(arrTotalShots[index],style: TextStyle(fontSize: 30)),
                                          Spacer(),
                                          Text(arrTotalTime[index],style: TextStyle(fontSize: 30)),
                                          Spacer(),

                                        ],
                                      ),
                                    ),

                                  ],
                                )



                            );
                          },
                        ),
                      ),

                    ]
                );
              }
          }
        },
      ),
    );
  }







  Future<String> userID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setDouble('userSensitivity', 50.00);
    String sUserID = await prefs.getString('id');

    //print(dSensitivity.toString());
    return sUserID;
  }
  _getID() async{
    var url = 'https://www.topshottimer.co.za/viewStrings.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          //get this information from user defaults
          "userID": sID,
        }
    );
    //print(json.decode(res.body));


    print("before res.body");

    List<dynamic> data = json.decode(res.body);
    int iLength = data.length;
    print("Length of list: " + iLength.toString());
    var id = data;
    print(id);
    print(id[0]['userID']);

    for(int iPopulate = 0; iPopulate<=iLength-1; iPopulate++)
    {
      arrStringID.add(id[iPopulate]['stringId']);
      arrStringName.add(id[iPopulate]['stringName']);
      arrTotalShots.add(id[iPopulate]['totalShots']);
      arrTotalTime.add(id[iPopulate]['totalTime']);
    }

    //print(arrStringName[0].toString());
    for(int iPrint = 0; iPrint<=iLength-1; iPrint++)
    {
      //print(arrStringName[iPrint]);
      print("String ID: " + arrStringID[iPrint]+ ", String Name: " + arrStringName[iPrint]+ ", Total Shots: " + arrTotalShots[iPrint].toString() + ", Total Time: " + arrTotalTime[iPrint]);
    }


    //sID == await userID();

    return userID();
  }

  Future<String> getData() async{


  }
}


