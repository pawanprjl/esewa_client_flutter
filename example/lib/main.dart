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
        "https://webhook.site/60342249-2a78-426b-9b4f-0ee7171b02ba");

    _esewaClient.startPayment(
        esewaPayment: payment,
        onSuccess: (data) {
          print("\n\n\n$data\n\n\n");
          print("success");
        },
        onFailure: (data) {
          print("\n\n\n$data\n\n\n");
          print("failure");
        },
        onCancelled: (data) {
          print("\n\n\n$data\n\n\n");
          print("cancelled");
        });
  }
}
