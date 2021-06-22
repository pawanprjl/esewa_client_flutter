# esewa_client

A flutter plugin to integrate ESEWA merchant services into your application.

## Getting Started

Add this dependency inside of your `pubspec.yaml`
```
dependencies:
    esewa_client: ^0.1.0
``` 

Add the following attribute inside your `AndroidManifest.xml` (this will set application level theme of your application to Theme.AppCompat descendant)

```
<application
...
android:theme="@style/Theme.AppCompat.Light.NoActionBar"
...>
...
</application>
```

Note: This plugin only supports **android** version for now (*IOS version coming soon*).

## How to Use
```
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

    // start your payment procedure
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
```