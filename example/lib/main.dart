import 'package:esewa_client/esewa_client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
            child: Text('Pay with esewa'),
            onPressed: _payViaEsewa,
          ),
        ),
      ),
    );
  }

  _payViaEsewa() async {
    // change credentials during production
    EsewaClient _esewaClient = EsewaClient.configure(
      clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
      secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
      environment: EsewaEnvironment.TEST,
    );

    /*
    * Enter your own callback url to receive response callback from esewa to your client server
    * */
    EsewaPayment payment = EsewaPayment(
        productId: "test_id",
        amount: "10",
        name: "Test Product",
        callbackUrl:
        "http://example.com/");

    _esewaClient.startPayment(
        esewaPayment: payment,
        onSuccess: (data) {
          print("success");
        },
        onFailure: (data) {
          print("failure");
        },
        onCancelled: (data) {
          print("cancelled");
        });
  }
}
