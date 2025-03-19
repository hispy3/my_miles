import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';
import 'package:http/http.dart' as http;
import 'app_strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Miles Auth',
      home: _SmartCarAuthMenu(),
    );
  }
}

class _SmartCarAuthMenu extends StatefulWidget {
  const _SmartCarAuthMenu();

  @override
  State<_SmartCarAuthMenu> createState() => _SmartCarAuthMenuState();
}

class _SmartCarAuthMenuState extends State<_SmartCarAuthMenu> {
  String? code;
  String? token;

  @override
  void initState() {
    super.initState();

    Smartcar.onSmartcarResponse.listen(_handleSmartCarResponse);
    setup();
  }

  Future<void> setup() async {
    await Smartcar.setup(
      configuration: const SmartcarConfig(
        clientId: clientId,
        redirectUri: redirectUri,
        scopes: [SmartcarPermission.readOdometer],
        mode: SmartcarMode.test,
      ),
    );
  }

  void _handleSmartCarResponse(SmartcarAuthResponse response) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    switch (response) {
      case SmartcarAuthSuccess success:
        getAccessToken(response.code ?? '');
        scaffoldMessenger.showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.green,
            content: Text(
              'code: ${success.code}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            actions: const [SizedBox.shrink()],
          ),
        );
        break;
      case SmartcarAuthFailure failure:
        scaffoldMessenger.showMaterialBanner(
          MaterialBanner(
            backgroundColor: Colors.redAccent,
            content: Text(
              'error: ${failure.description}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            actions: const [SizedBox.shrink()],
          ),
        );
        break;
    }

    Future.delayed(
      const Duration(
        seconds: 3,
      ),
    ).then((_) => scaffoldMessenger.hideCurrentMaterialBanner());
  }

  Future<void> getAccessToken(String code) async {
    if (code.isNotEmpty) {
      String token = await fetchAccessToken(code);
      await getVehicleData(token);
    }
  }

  Future<void> getVehicleData(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.smartcar.com/v2.0/vehicles'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = json.decode(response.body);
    List<String> vehicleIds = data['vehicles'];
    await getFuelLevel(vehicleIds.first, accessToken);
  }

  Future<void> getFuelLevel(String vehicleId, String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.smartcar.com/v2.0/vehicles/$vehicleId/fuel'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final data = json.decode(response.body);
    print(data);
  }

  // Fetch the access token from SmartCar using the authorization code
  Future<String> fetchAccessToken(String code) async {
    final response = await http.post(
      Uri.parse('https://auth.smartcar.com/oauth/token'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
      },
    );
    final data = json.decode(response.body);
    return data['access_token'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Miles Auth'),
      ),
      body: Visibility(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () async {
                  await Smartcar.launchAuthFlow();
                },
                child: const Text("Launch Auth Flow"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
