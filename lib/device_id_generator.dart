import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';


class DeviceIdHelper {
  static Future<String> getToken() async {
    final deviceInfo = DeviceInfoPlugin();
    String rawId;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      rawId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      rawId = iosInfo.identifierForVendor ?? "unknown-ios";
    } else {
      rawId = "unsupported-platform";
    }

    final bytes = utf8.encode(rawId);
    final digest = sha256.convert(bytes).toString();
    final deviceId = digest.substring(0, 16);

    // Token de 8 chars
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    BigInt hashInt = BigInt.parse(digest.substring(0, 16), radix: 16);
    String token = '';
    for (int i = 0; i < 8; i++) {
      token += chars[hashInt.remainder(BigInt.from(chars.length)).toInt()];
      hashInt = hashInt ~/ BigInt.from(chars.length);
    }

    return token;
  }
}



class DeviceIdGenerator extends StatefulWidget {
  @override
  _DeviceIdGeneratorState createState() => _DeviceIdGeneratorState();
}

class _DeviceIdGeneratorState extends State<DeviceIdGenerator> {
  String _deviceId = "Generando...";
  String _token = "Generando...";

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    String rawId;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      rawId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      rawId = iosInfo.identifierForVendor ?? "unknown-ios";
    } else {
      rawId = "unsupported-platform";
    }

    // Hash interno del dispositivo (16 chars)
    String deviceId = _hashId(rawId).substring(0, 16);
    // Token corto de 8 chars para registrar
    String token = _generateShortToken(deviceId, length: 8);

    setState(() {
      _deviceId = deviceId;
      _token = token;
    });
  }

  // SHA-256 hash
  String _hashId(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Genera token legible de n caracteres
  String _generateShortToken(String deviceId, {int length = 8}) {
    final bytes = utf8.encode(deviceId);
    final digest = sha256.convert(bytes);
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    BigInt hashInt = BigInt.parse(digest.toString().substring(0, 16), radix: 16);
    String token = '';
    for (int i = 0; i < length; i++) {
      token += chars[hashInt.remainder(BigInt.from(chars.length)).toInt()];
      hashInt = hashInt ~/ BigInt.from(chars.length);
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ID de Dispositivo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ID único interno:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            SelectableText(_deviceId, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Token corto para registro:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            SelectableText(_token, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
