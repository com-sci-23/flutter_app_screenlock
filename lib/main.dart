import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LocalAuthen/passcode.dart';
import 'LocalAuthen/set_pincode.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final StreamController<bool> _verificationNotifier =
  StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasscodeScreen(

        title: Text(
          'กรุณากำหนดรหัสผ่าน',
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
    );
  }

  ///ฟังชั่นตรวจสอบ
  _onPassCodeEntered(String enteredPassCode) {
    String pin;
    bool isValid = pin == enteredPassCode;
    print('print1 $enteredPassCode');
    _verificationNotifier.add(isValid);
    if (enteredPassCode != null) {
      setPinCode(enteredPassCode);
      print('print2 $enteredPassCode');
    }
    if (enteredPassCode != null) {
      setState(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SetPinPage()),
        );
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
}






