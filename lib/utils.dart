import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_messenger/flutter_background_messenger.dart';

Future<void> requestPermission({
  required Permission permission,
  required Telephony telephonyInstance,
}) async {
  final status = await permission.status;
  bool? granted = await telephonyInstance.requestPhoneAndSmsPermissions;
  debugPrint("Telephony Permission granted: $granted");
  if (status.isGranted) {
    debugPrint("Permission is already granted.");
  } else if (status.isDenied) {
    if (await permission.request().isGranted) {
      debugPrint("Permission granted.");
    } else {
      debugPrint("Permission denied.");
    }
  } else {
    debugPrint("Permission denied.");
  }
}

final messenger = FlutterBackgroundMessenger();

Future<void> sendSMS(String phoneNumber, String text) async {
  try {
    final success = await messenger.sendSMS(
      phoneNumber: phoneNumber,
      message: text,
    );

    if (success) {
      debugPrint('SMS sent successfully');
    } else {
      debugPrint('Failed to send SMS');
    }
  } catch (e) {
    debugPrint('Error sending SMS: $e');
  }
}
