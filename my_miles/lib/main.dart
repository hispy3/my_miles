import 'package:flutter/material.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';
import 'package:my_miles/repository/repository.dart';
import 'package:my_miles/views/Item_view.dart';

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
        List<String> vehicleListRep =
            await repository.getVehicleData(bearerToken);

        final response = await Future.wait([
          repository.getVehicleInfo(vehicleListRep.first, bearerToken),
          repository.getOdometerInfo(vehicleListRep.first, bearerToken),
          repository.getEVBatteryLevel(vehicleListRep.first, bearerToken),
          repository.getEVBatteryCapacity(vehicleListRep.first, bearerToken),
        ]);

        vehicleInfoModelData = response[0];
        odometerInfoModelData = response[1];
        evBatteryLevelInfoModelData = response[2];
        evBatteryCapacityInfoModelData = response[3];

        setState(() {
          token = bearerToken;
          vehicleList = vehicleListRep;
        });
      }
    }
  }

  Future<void> getAccessToken(String code, {bool isTokenSaved = false}) async {
    String? bearerToken;

    if (code.isNotEmpty) {
      bearerToken = await repository.fetchAccessToken(code);
    }

    if (bearerToken != null) {
      List<String> vehicleListRep =
          await repository.getVehicleData(bearerToken);
      final response = await Future.wait([
        repository.getVehicleInfo(vehicleListRep.first, bearerToken),
        repository.getOdometerInfo(vehicleListRep.first, bearerToken),
        repository.getEVBatteryLevel(vehicleListRep.first, bearerToken),
        repository.getEVBatteryCapacity(vehicleListRep.first, bearerToken),
      ]);

      vehicleInfoModelData = response[0];
      odometerInfoModelData = response[1];
      evBatteryLevelInfoModelData = response[2];
      evBatteryCapacityInfoModelData = response[3];

      setState(() {
        token = bearerToken;
        vehicleList = vehicleListRep;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Miles Auth'),
      ),
      body: Column(
        children: [
          Visibility(
            visible: vehicleList.isEmpty,
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
          Visibility(
              visible: vehicleList.isNotEmpty,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Vehicle Info',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ItemView(
                        title: 'Make',
                        value: vehicleInfoModelData?.make ?? '',
                      ),
                      ItemView(
                        title: 'Model',
                        value: vehicleInfoModelData?.model ?? '',
                      ),
                      ItemView(
                          title: 'Year',
                          value: '${vehicleInfoModelData?.year ?? ''}'),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Odometer',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ItemView(
                        title: 'Distance',
                        value: '${odometerInfoModelData?.distance ?? '0'}km',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'EV Battery Level',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ItemView(
                        title: 'PerCent Remaining',
                        value:
                            '${(evBatteryLevelInfoModelData?.percentRemaining ?? 0) * 100}%',
                      ),
                      ItemView(
                        title: 'Range',
                        value: '${evBatteryLevelInfoModelData?.range ?? '0'}km',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'EV Battery Capacity',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ItemView(
                        title: 'Capacity',
                        value:
                            '${evBatteryCapacityInfoModelData?.capacity ?? '0'}kWh',
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
