import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_screenlock/LocalAuthen/passcode.dart';
import 'package:flutter_app_screenlock/fingerAndFaceScan/api_auth.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SetPinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final StreamController<bool> _verificationNotifier =
  StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkPreferance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PasscodeScreen(
            title: Text(
              'ยืนยันรหัสผ่าน',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xff133979), fontSize: 16),
            ),
            circleUIConfig: CircleUIConfig(
                borderColor: Color(0xff827553),
                fillColor: Color(0xff827553),
                circleSize: 30),
            keyboardUIConfig: KeyboardUIConfig(
              digitTextStyle: TextStyle(color: Color(0xff827553), fontSize: 26),
              digitBorderWidth: 1,
              primaryColor: Color(0xff827553),
            ),
            passwordEnteredCallback: _onPassCodeEntered,
            cancelButton: Icon(
              Icons.arrow_back,
              color: Color(0xff827553),
            ),
            deleteButton: Text(
              'ยกเลิก',
              style: const TextStyle(fontSize: 16, color: Color(0xff827553)),
              semanticsLabel: 'ยกเลิก',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.white,
            cancelCallback: _onPassCodeCancelled,
            digits: [
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
              '9',
              '0',
            ],
            passwordDigits: 6,
          ),
          _resetButton()
        ],
      ),
    );
  }

  ///ฟังชั่นตรวจสอบ
  _onPassCodeEntered(String enteredPassCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String pin = preferences.getString(
      'enteredPassCode',
    );
    print('Test $pin');
    bool isValid = pin == enteredPassCode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        pin == enteredPassCode
            ? Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SetPassCodePage()),
        )
            : SizedBox();
      });
    }
  }

  Future<void> setPinCode(String enteredPassCode) async {
    print('print3 $enteredPassCode');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('enteredPassCode', enteredPassCode);
  }

  Future<void> checkPreference() async {
    print('show2');
    try {
      print('show3');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String enteredPassCode = preferences.getString(
        'enteredPassCode',
      );
      if (enteredPassCode != null && enteredPassCode.isNotEmpty) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SetPassCodePage()));
      }
    } catch (e) {}
  }

  ///ฟังชั่นยกเลิก
  _onPassCodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  _resetButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Column(
      children: [
        // Container(
        //   margin: const EdgeInsets.only(right: 220.0, top: 600.0),
        //   child: TextButton(
        //     child: Icon(
        //       Icons.fingerprint_rounded,
        //       color: Colors.red,
        //       size: 70.0,
        //     ),
        //     // onPressed: () => Navigator.of(context).pushReplacement(
        //     //   MaterialPageRoute(builder: (context) => HomePage()),
        //     // ),
        //     onPressed: () async {
        //       final isAuthenticated = await LocalAuthApi.authenticate();
        //       if (isAuthenticated) {
        //         Navigator.of(context).pushReplacement(
        //           MaterialPageRoute(builder: (context) => HomePage()),
        //         );
        //       }
        //     },
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 700),
          child: Container(
            //margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
            child: TextButton(
              child: Text(
                "ย้อนกลับ",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w300),
              ),
              onPressed: () => LocalAuthApi().signOutProcess(context),
            ),
          ),
        ),
      ],
    ),
  );
}