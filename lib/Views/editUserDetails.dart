import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/main.dart';
import 'package:http/http.dart' as http;
import 'package:basic_utils/basic_utils.dart';



class editUserDetails extends StatefulWidget {
  @override
  _editUserDetailsState createState() => _editUserDetailsState();
}

class _editUserDetailsState extends State<editUserDetails> {
  Future newSensitivityFuture;
  Future newDelayFuture;
  Future fFirstName;
  Future fLastName;
  Future fEmail;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




  @override
  void initState(){
    super.initState();
    initPlayer();
    fFirstName = _getFirstName();
    fLastName = _getLastName();
    fEmail = _getEmail();
    newDelayFuture = _getDelay();
    newSensitivityFuture = _getSensitivity();
  }

  _getFirstName() async{
    FirstName = await userFirstName();
    return userFirstName();
  }

  _getLastName() async{
    LastName = await userLastName();
    return userLastName();
  }

  _getEmail() async {
    Email = await userEmail();
    return userEmail();
  }

  _getDelay() async{
    sliderValue2 = await userDelay();
    if (sliderValue2 == null)
    {
      sliderValue2 = 3;
    }
    return userDelay();
  }

  _getSensitivity() async{
    sliderValue1 = await userSensitivity();
    if (sliderValue1 == null)
    {
      sliderValue1 = 50.0;
    }

    return userSensitivity();
  }

  getDetails() async{

  }
  // Store both of these values in user defaults
  //Stewart Knows How User Defaults Works
  //**********************************************
  double sliderValue1 = 0;
  double sliderValue2 = 1;
  String FirstName = "";
  String newFirstName = "";
  String LastName = "";
  String newLastName = "";
  String Email = "";

  int dropDownValue = 1;
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String localPathFile;

  //var sHello = await userSensitivity(context);
  //**********************************************




  void initPlayer(){
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(""), iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),),
      body: Container(
        padding: EdgeInsets.only(top: 35,bottom: 20,left: 20, right: 20),
        child: FutureBuilder(

          future: newSensitivityFuture,
          builder: (context, snapshot )  {

            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
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
                ); //or a placeholder
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error Here: ${snapshot.error}');
                } else {
                  print(sliderValue1);
                  print(FirstName);

                  return Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20,bottom: 0,left: 0, right: 0),
                              //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(Icons.perm_identity, color: Theme.of(context).iconTheme.color,),
                              ),
                              initialValue: FirstName,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'First Name is Required';
                                }
                                //regex

                                return null;
                              },
                              onSaved: (String value) {
                                newFirstName = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: Icon(Icons.perm_identity, color: Theme.of(context).iconTheme.color,),
                              ),
                              initialValue: LastName,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Last Name is Required';
                                }
                                //regex

                                return null;
                              },
                              onSaved: (String value) {
                                newLastName = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email, color: Theme.of(context).iconTheme.color,),
                              ),
                              initialValue: Email,
                              enabled: false,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Email is Required';
                                }
                                //regex

                                return null;
                              },
                              onSaved: (String value) {
                                Email = value;
                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
                              //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                            ),



                            FlatButton(
                              color: Themes.darkButton1Color,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Themes.darkButton1Color)),
                              height: 50,
                              minWidth: 220,
                              child: Text("Reset Password",style: TextStyle(fontSize: 20,color: Theme.of(context).buttonColor ),),
                              onPressed: () async {
                                resetPasswordDialog();

                              },


                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
                              //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                            ),


                            Row(
                              children: [

                                FlatButton(
                                  color: Themes.darkButton1Color,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Color(0xFF2C5D63))),
                                  height: 50,
                                  minWidth: 180,
                                  child: Text("Back",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),),
                                  onPressed: () {
                                    //resetPassword(Email.toLowerCase());
                                    Navigator.pop(context);
                                    //Navigator.pushReplacementNamed(context, '/Settings');
                                    print("Back Clicked");                            },


                                ),
                                Spacer(),
                                FlatButton(
                                  color: Themes.darkButton2Color,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Color(0xFFA2C11C))),
                                  height: 50,
                                  minWidth: 180,
                                  child: Text("Update",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),),
                                  onPressed: () {
                                    print("Hello world");
                                    print(newFirstName);

                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }

                                    _formKey.currentState.save();
                                    newFirstName = StringUtils.capitalize(newFirstName);
                                    newLastName = StringUtils.capitalize(newLastName);

                                    print(newFirstName.replaceAll(new RegExp(r"\s+"), ""));
                                    print(newLastName);
                                    print(Email.toLowerCase());
                                    updateUserDefaults(newFirstName, newLastName);
                                    updateDetails(newFirstName, newLastName, Email);


                                    //TODO Needs to navigate to Page selector and have a popup dialog

                                  },


                                ),

                              ],

                            ),






                          ],

                        ),

                      ),






                      // Text('First Name: ', style: TextStyle(
                      //     fontSize: 28.0, color: Themes.darkButton2Color),),
                      // Text(FirstName.toString(), style: TextStyle(
                      //     fontSize: 20.0
                      // ),),
                      //
                      // Text('Last Name: ', style: TextStyle(
                      //     fontSize: 28.0, color: Themes.darkButton2Color
                      // ),),
                      // Text(LastName.toString(), style: TextStyle(
                      //     fontSize: 20.0
                      // ),),
                      // Text('Email: ', style: TextStyle(
                      //     fontSize: 28.0, color: Themes.darkButton2Color
                      // ),),
                      // Text(Email.toString(), style: TextStyle(
                      //     fontSize: 20.0
                      // ),),









                    ],
                  );
                }
            }
          },

        ),
      ),
    );

  }

  resetPasswordDialog(){
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgoundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 140,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Send a password reset email?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 20,),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.only(bottomLeft: Radius.circular(10)),
                                color: Themes.darkButton1Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Cancel",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              print("Delete Clicked");
                              resetPassword(Email.toLowerCase());
                              clearDefaults();
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                              print("Signed Out");
                              Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
                              // Navigator.pop(context);
                              //Navigator.push(context,
                              // MaterialPageRoute(builder: (context) => SignUp(_email.text)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.only(bottomRight: Radius.circular(10)),
                                //color: Themes.PrimaryColorRed,
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Send Email",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                    backgroundColor: Themes.darkButton2Color,
                    radius: 40,
                    child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                )
            ),
          ],
        )
    );
    showDialog(context: context, builder: (context) => dialog);

  }
}

// doStuff() async{
//   var x = await userSensitivity();
//   return x;
// }
resetPassword(String email) async{
  try{
    var url = 'https://www.topshottimer.co.za/resetPasswordMailer.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          "emailAddress": email,
        }
    );
    print("Password Reset Sent");

    //Navigator.of(context).pop();
    //Navigator.push(context, MaterialPageRoute(builder: (context) => con.resetPasswordConfirm(email)));
    //Navigator.pushNamedAndRemoveUntil(context, '/LoginSignUp/resetPasswordConfirm', (r) => false ,arguments: {'email': email});

  }catch (error) {
    print(error.toString());
    //setState(() => loading = false);
  }
}

updateDetails(String name, String surname, String email) async{
  try{
    var url = 'https://www.topshottimer.co.za/updateUserDetails.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          "firstName": name,
          "lastName": surname,
          "emailAddress": email,
        }
    );
    //Navigator.of(context).pop();
    //Navigator.push(context, MaterialPageRoute(builder: (context) => con.resetPasswordConfirm(email)));
    //Navigator.pushNamedAndRemoveUntil(context, '/LoginSignUp/resetPasswordConfirm', (r) => false ,arguments: {'email': email});

  }catch (error) {
    print(error.toString());
    //setState(() => loading = false);
  }
}
updateUserDefaults(String name, String surname) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('firstName', name);
  await prefs.setString('lastName', surname);

}

clearDefaults() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

Future <String> userFirstName() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  String sFirstName = await prefs.getString('firstName');

  //print(dSensitivity.toString());
  return sFirstName;

}

Future <String> userLastName() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  String sLastName = await prefs.getString('lastName');

  //print(dSensitivity.toString());
  return sLastName;

}

Future <String> userEmail() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  String sEmail = await prefs.getString('email');

  //print(dSensitivity.toString());
  return sEmail;

}


Future<double> userSensitivity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  double dSensitivity = await prefs.getDouble('userSensitivity');
  if (dSensitivity == null){
    await prefs.setDouble('userSensitivity', 50.0);
  }
  //print(dSensitivity.toString());
  return dSensitivity;
}

setDefaultSensitivity(double newValue) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('userSensitivity', newValue);

}

Future<double> userDelay() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  double dDelay = await prefs.getDouble('userDelay');
  if (dDelay == null){
    await prefs.setDouble('userDelay', 3);
  }
  //print(dSensitivity.toString());
  return dDelay;
}

setDefaultDelay(double newValue) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('userDelay', newValue);

}

Future<String> userTone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  String sTone = await prefs.getString('userTone');
  if (sTone == null){
    await prefs.setString('userTone', "1500");
  }
  //print(dSensitivity.toString());
  return sTone;
}

setUserTone(String newValue) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userTone', newValue);
  print("New user tone was set to: "+ newValue);

}
