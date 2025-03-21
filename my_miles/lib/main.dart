import 'package:flutter/material.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';
import 'package:my_miles/repository/repository.dart';
import 'package:my_miles/views/vehicle_info.dart';


import 'constants/colors.dart';
import 'models/vehicle_info_model.dart';

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
      debugShowCheckedModeBanner: false,
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
  MyMilesRepository repository = MyMilesRepository();
  String? token;
  List<String> vehicleList = List.empty(growable: true);
  VehicleInfoModel? vehicleInfoModelData,
      odometerInfoModelData,
      evBatteryLevelInfoModelData,
      evBatteryCapacityInfoModelData;

  @override
  void initState() {
    super.initState();
    Smartcar.onSmartcarResponse.listen(_handleSmartCarResponse);
    repository.myMilesSetup();
    checkTokenAvailability();
  }

  void _handleSmartCarResponse(SmartcarAuthResponse response) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    switch (response) {
      case SmartcarAuthSuccess success:
        getAccessToken(response.code ?? '');
        // scaffoldMessenger.showMaterialBanner(
        //   MaterialBanner(
        //     backgroundColor: Colors.green,
        //     content: Text(
        //       'code: ${success.code}',
        //       style: const TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //     actions: const [SizedBox.shrink()],
        //   ),
        // );
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

  void checkTokenAvailability() async {
    String? isTokenAvailable = await repository.getToken();
    String? bearerToken;
    if (isTokenAvailable != null) {
      bearerToken = await repository.getToken();
      if (bearerToken != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VehicleInfo(bearerToken: bearerToken!)));
      }
    }
  }

  Future<void> getAccessToken(String code, {bool isTokenSaved = false}) async {
    String? bearerToken;

    if (code.isNotEmpty) {
      bearerToken = await repository.fetchAccessToken(code);
    }

    if (bearerToken != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VehicleInfo(bearerToken: bearerToken!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
            child: Center(
              child: Text("Connect Your Car",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: mainFontColor,
                  )),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
            child: Center(
              child: Text("Seamlessly Connect & Monitor Your Car",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: mainFontColor,
                  )),
            ),
          ),
          Container(
            height: 50,
          ),
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("lib/assets/steering-wheel.png"),
                    fit: BoxFit.cover)),
          ),
          Container(
            height: 80,
          ),
          GestureDetector(
            onTap: () async {
              await Smartcar.launchAuthFlow();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: buttoncolor, borderRadius: BorderRadius.circular(25)),
              child: const Center(
                child: Text(
                  "Connect Your Car",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ]))));
  }
}
