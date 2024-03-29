import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Themes.dart';
import 'package:http/http.dart';
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

  bool bConnected = false;

  @override
  void initState() {
    super.initState();
    Purchases.getPurchaserInfo();
    fFirstName = _getFirstName();
    fLastName = _getLastName();
    fEmail = _getEmail();
    newDelayFuture = _getDelay();
    newSensitivityFuture = _getSensitivity();
  }

  _getFirstName() async {
    FirstName = await userFirstName();
    return userFirstName();
  }

  _getLastName() async {
    LastName = await userLastName();
    return userLastName();
  }

  _getEmail() async {
    Email = await userEmail();
    return userEmail();
  }

  _getDelay() async {
    sliderValue2 = await userDelay();
    if (sliderValue2 == null) {
      sliderValue2 = 3;
    }
    return userDelay();
  }

  _getSensitivity() async {
    sliderValue1 = await userSensitivity();
    if (sliderValue1 == null) {
      sliderValue1 = 30;
    }

    return userSensitivity();
  }

  getDetails() async {}

  int sliderValue1 = 0;
  double sliderValue2 = 1;
  String FirstName = "";
  String newFirstName = "";
  String LastName = "";
  String newLastName = "";
  String Email = "";

  int dropDownValue = 1;
  String localPathFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Details", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
        child: FutureBuilder(
          future: newSensitivityFuture,
          builder: (context, snapshot) {
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              initialValue: FirstName,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'First Name is Required';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                newFirstName = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              initialValue: LastName,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Last Name is Required';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                newLastName = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              initialValue: Email,
                              enabled: false,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Email is Required';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                Email = value;
                              },
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 0, left: 0, right: 0),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            SizedBox(
                                width: 220,
                                height: 50,
                                child: ElevatedButton(
                                  child: Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      fontFamily: 'Montserrat-Regular',
                                      letterSpacing: 0.2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    resetPasswordDialog();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Themes.darkButton1Color,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10))),
                                )),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 0, left: 0, right: 0),
                              //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
                            ),

                            SizedBox(
                                width: 180,
                                height: 50,
                                child: ElevatedButton(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      fontFamily: 'Montserrat-Regular',
                                      letterSpacing: 0.2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    print("**FirstName: " + FirstName);
                                    print("**LastName: " + LastName);
                                    print("**NewFirstName: " + newFirstName);
                                    print("**NewLastName: " + newLastName);

                                    //print("Hello world");
                                    print(newFirstName);

                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }
                                    _formKey.currentState.save();

                                    if (newFirstName == FirstName &&
                                        newLastName == LastName) {
                                      print("***********No Details Were Edited");
                                      print("**NewFirstName: " + newFirstName);
                                      print("**NewLastName: " + newLastName);
                                      //_formKey.currentState.save();
                                      notUpdateDetailsDialog();
                                    } else {
                                      print("***********Details Were Edited");
                                      print("**NewFirstName: " + newFirstName);
                                      print("**NewLastName: " + newLastName);
                                      newFirstName =
                                          StringUtils.capitalize(newFirstName);
                                      newLastName =
                                          StringUtils.capitalize(newLastName);

                                      print(newFirstName.replaceAll(
                                          new RegExp(r"\s+"), ""));
                                      print(newLastName);
                                      print(Email.toLowerCase());
                                      updateUserDefaults(newFirstName, newLastName);
                                      updateDetails(
                                          newFirstName, newLastName, Email);
                                      updateDetailsDialog();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Themes.darkButton2Color,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10))),
                                )),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                break;
              default:
                return Text("");
            }
          },
        ),
      ),
    );
  }

  resetPasswordDialog() {
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 205,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                        "Are you sure you would like to reset your password. By confirming this you will be logged out.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10)),
                                color: Themes.darkButton1Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              resetPassword(Email.toLowerCase());
                              clearDefaults();
                              print("Signed Out");
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/LoginSignUp/resetPasswordConfirm',
                              (route) => false,
                              arguments: {'email': Email.toLowerCase()});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10)),
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Confirm",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
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
                    child: Image.asset(
                      "assets/Exclamation@3x.png",
                      height: 53,
                    ))),
          ],
        ));
    showDialog(context: context, builder: (context) => dialog);
  }

  notUpdateDetailsDialog() {
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 180,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Your details were not edited. Please change your details before clicking update.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Close",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
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
                    child: Image.asset(
                      "assets/Exclamation@3x.png",
                      height: 53,
                    ))),
          ],
        ));
    showDialog(context: context, builder: (context) => dialog);
  }

  updateDetailsDialog() {
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 160,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Your details have been updated successfully. Thank you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/PageSelector');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Continue",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
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
                    child: Image.asset(
                      "assets/Exclamation@3x.png",
                      height: 53,
                    ))),
          ],
        ));
    showDialog(context: context, builder: (context) => dialog);
  }
}

resetPassword(String email) async {
  try {
    var url =
        'https://authentication.topshottimer.co.za/authentication/resetPasswordMailer.php';
    await post(Uri.parse(url), headers: {
      "Accept": "application/jason"
    }, body: {
      "emailAddress": email,
    });
    print("Password Reset Sent");
  } catch (error) {
    print(error.toString());
  }
}

updateDetails(String name, String surname, String email) async {
  try {
    var url = 'https://www.topshottimer.co.za/updateUserDetails.php';
    await post(Uri.parse(url), headers: {
      "Accept": "application/jason"
    }, body: {
      "firstName": name,
      "lastName": surname,
      "emailAddress": email,
    });
  } catch (error) {
    print(error.toString());
  }
}

updateUserDefaults(String name, String surname) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('firstName', name);
  await prefs.setString('lastName', surname);
}

clearDefaults() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

Future<String> userFirstName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sFirstName = prefs.getString('firstName');

  return sFirstName;
}

Future<String> userLastName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sLastName = prefs.getString('lastName');
  return sLastName;
}

Future<String> userEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sEmail = prefs.getString('email');
  return sEmail;
}

Future<int> userSensitivity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int dSensitivity = prefs.getInt('userSensitivity');
  if (dSensitivity == null) {
    await prefs.setInt('userSensitivity', 30);
  }
  return dSensitivity;
}

setDefaultSensitivity(double newValue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('userSensitivity', newValue);
}

Future<double> userDelay() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double dDelay = prefs.getDouble('userDelay');
  if (dDelay == null) {
    await prefs.setDouble('userDelay', 3);
  }
  return dDelay;
}

setDefaultDelay(double newValue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('userDelay', newValue);
}

Future<String> userTone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String sTone = prefs.getString('userTone');
  if (sTone == null) {
    await prefs.setString('userTone', "1500");
  }
  return sTone;
}

setUserTone(String newValue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userTone', newValue);
  print("New user tone was set to: " + newValue);
}
