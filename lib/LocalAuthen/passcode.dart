import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_screenlock/caculate/calculator_screen.dart';
import 'package:flutter_app_screenlock/fingerAndFaceScan/api_auth.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class SetPassCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetPassCodePageState();
}

class _SetPassCodePageState extends State<SetPassCodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PasscodeScreen(
            title: Text(
              'กรุณาใส่รหัสผ่าน',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            circleUIConfig: CircleUIConfig(
                borderColor: Color(0xff827553),
                fillColor: Color(0xff827553),
                circleSize: 20),
            keyboardUIConfig: KeyboardUIConfig(
              deleteButtonTextStyle:
                  const TextStyle(fontSize: 16, color: Colors.red),
              digitTextStyle: TextStyle(color: Color(0xff827553), fontSize: 26),
              digitBorderWidth: 1,
              primaryColor: Color(0xff827553),
            ),
            passwordEnteredCallback: _onPassCodeEntered,
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.white,
            //backgroundColor: Colors.black.withOpacity(0.8),

            cancelCallback: _onPasscodeCancelled,
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
            // deleteButton: Container(
            //   //margin: EdgeInsets.all(20),
            //   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(0.5),
            //       border: Border.all(width: 1, color: Colors.white)),
            //   child: Icon(
            //     Icons.backspace_outlined,
            //     color: Color(0xff827553),
            //     size: 40.0,
            //   ),
            // ),
            // cancelButton: Container(
            //   //margin: EdgeInsets.all(20),
            //   padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(0.5),
            //       border: Border.all(width: 1, color: Colors.white)),
            //   child: Icon(
            //     Icons.backspace_outlined,
            //     color: Color(0xff827553),
            //     size: 40.0,
            //   ),
            // ),

            deleteButton: Container(
              //color: Colors.red,
              child: Icon(

                Icons.backspace_outlined,
                color: Color(0xff827553),
                size: 30.0,

              ),
            ),


            cancelButton: Container(
              //color: Colors.red,
              child: Icon(
                Icons.backspace_outlined,
                color: Color(0xff827553),
                size: 30.0,
              ),
            ),
            // cancelButton: Container(
            //   color: Colors.red,
            //   child: Padding(
            //     //padding: const EdgeInsets.only(top: 530, right:40),
            //     child: Container(
            //       color: Colors.red,
            //       child: Column(
            //         children: [
            //           Icon(
            //             Icons.backspace,
            //             color: Color(0xff827553),
            //             size: 40.0,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // deleteButton: Text(
            //   'ยกเลิก',
            //   style: const TextStyle(fontSize: 16, color: Color(0xff827553)),
            //   semanticsLabel: 'ยกเลิก',
            // ),
            //bottomWidget: _buildPasscodeRestoreButton2(),
          ),
          _resetButton()
        ],
      ),
    );
  }

  //ตรวจสอบ
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
                MaterialPageRoute(builder: (context) => CalculatorScreen()),
              )
            : SizedBox();
      });
    }
  }

  //ฟังชั่นปิด
  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  //ปุ่มแสกนหน้า
  _resetButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 220.0, top: 600.0),
              child: TextButton(
                child: Icon(
                  Icons.fingerprint_rounded,
                  color: Colors.red,
                  size: 70.0,
                ),
                // onPressed: () => Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (context) => HomePage()),
                // ),
                onPressed: () async {
                  final isAuthenticated = await LocalAuthApi.authenticate();
                  if (isAuthenticated) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => CalculatorScreen()),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                //margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                child: TextButton(
                  child: Text(
                    "ลืมรหัสผ่าน",
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
