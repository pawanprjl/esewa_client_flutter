import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EsewaClient {
  static const MethodChannel _channel = const MethodChannel('esewa_client');

  final String clientId, secretKey;
  final EsewaEnvironment environment;

  EsewaClient.configure({
    required this.clientId,
    required this.secretKey,
    this.environment = EsewaEnvironment.TEST,
  });

  void startPayment({
    required EsewaPayment esewaPayment,
    required Function onSuccess,
    required Function onFailure,
    required Function onCancelled,
  }) async {
    _channel.invokeMethod("esewa#startPayment", {
      "client_id": clientId,
      "secret_key": secretKey,
      "payment": esewaPayment.toMap(),
      "environment": describeEnum(environment),
    });
    _listenToResponse(onSuccess, onFailure, onCancelled);
  }

  _listenToResponse(
      Function onSuccess, Function onFailure, Function onCancelled) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "esewa#success":
          onSuccess(call.arguments);
          break;

        case "esewa#cancelled":
          onCancelled(call.arguments);
          break;

        case "esewa#invalid":
          onFailure(call.arguments);
          break;
        default:
      }
    });
  }
}

class EsewaPayment {
  final String productId, amount, name, callbackUrl;

  EsewaPayment({
    required this.productId,
    required this.amount,
    required this.name,
    required this.callbackUrl,
  });

  Map<String, dynamic> toMap() => {
        "product_id": productId,
        "amount": amount,
        "product_name": name,
        "callback_url": callbackUrl,
      };
}

enum EsewaEnvironment { TEST, LIVE }
