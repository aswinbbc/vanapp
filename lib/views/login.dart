import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:vanapp/utils/constants/colors.dart';
import 'package:vanapp/utils/constants/utils.dart';
import 'package:vanapp/views/home_screen.dart';
import '../utils/constants/constant.dart';
import '../utils/network_service.dart';
import '/widgets/form_button.dart';
import '/widgets/input_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'settings_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email, password;
  String? emailError, passwordError;
  BuildContext? myContext;

  var checker = false;

  @override
  void initState() {
    super.initState();

    Constants.userId.then((value) {
      // Route route = MaterialPageRoute(builder: (context) => Dashboard());
      // Navigator.pushReplacement(myContext!, route);
    });
    email = "";
    password = "";

    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty) {
      setState(() {
        emailError = "Username is invalid";
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Please enter a password";
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      login(email, password, context);
    }
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await launchUrl(
                  Uri.parse("https://www.amalgamatetechnologies.com/"));
            },
            child: AutoSizeText(
              'AMALGAMATE TECHNOLOGIES',
              maxLines: 1,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(color: Colors.black),
          AutoSizeText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Innovation at its',
                ),
                TextSpan(
                  text: ' peack',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TextSpan(
                //   text: ' lighting solution',
                // ),
              ],
            ),
            style: TextStyle(fontSize: 10),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image.asset(
          //   'assets/images/zoomie.png',
          //   height: 120,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(height: 1),
              _buildBody(),
              FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                              appBar: AppBar(), body: const SettingsScreen()),
                        ));
                  },
                  child: const Icon(Icons.settings)),
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/wave.gif',
              // height: 120,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return ListView(
                  children: [
                    SizedBox(height: screenHeight * .05),
                    Image.asset(
                      'assets/panda.gif',
                      height: 150,
                    ),
                    ...loginPage(screenHeight),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/panda.gif',
                          height: 220,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: loginPage(screenHeight),
                    ))
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  List<Widget> loginPage(screenHeight) {
    return [
      SizedBox(height: screenHeight * .05),
      Visibility(
        child: Center(child: CircularProgressIndicator()),
        visible: checker,
      ),
      InputField(
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
        labelText: "Username",
        errorText: emailError,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autoFocus: true,
      ),
      SizedBox(height: screenHeight * .025),
      InputField(
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        onSubmitted: (val) => submit(),
        labelText: "Password",
        errorText: passwordError,
        obscureText: true,
        textInputAction: TextInputAction.next,
      ),
      SizedBox(
        height: screenHeight * .075,
      ),
      GFButton(
        text: "Log In",
        onPressed: submit,
        shape: GFButtonShape.pills,
      ),
      SizedBox(
        height: screenHeight * .015,
      ),
    ];
  }

  login(String? email, String? password, context) {
    loadServerData("AppUser/CheckUserExist",
            params: {
              "UserName": email,
              "Password": password,
            },
            post: true)
        .then((value) async {
      try {
        // print(value.first);
        if (value.first.containsKey('UserID')) {
          // Obtain shared preferences.

          await Constants().setUserId(value.first['UserID']);
          await Constants().setUserName(value.first['UserName']);
          showToast("welcome.");

          Route route =
              MaterialPageRoute(builder: (context) => const HomeScreen());
          Navigator.pushReplacement(myContext!, route);
        } else {
          showToast("username or password incorrect.");
        }
      } catch (e) {
        showToast("username or password incorrect.");
      }
    });
  }
}
