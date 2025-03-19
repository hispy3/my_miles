import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';
import 'package:my_miles/repository/repository.dart';
import 'package:my_miles/views/vehicle_info.dart';

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
  late String token;
  List<String> vehicleList = List.empty(growable: true);
  VehicleInfoModel? vehicleInfoModelData;

  @override
  void initState() {
    super.initState();
    Smartcar.onSmartcarResponse.listen(_handleSmartCarResponse);
    repository.myMilesSetup();
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

  Future<void> getAccessToken(String code) async {
    if (code.isNotEmpty) {
      String bearertoken = await repository.fetchAccessToken(code);
      List<String> vehicleListRep =
          await repository.getVehicleData(bearertoken);
      vehicleInfoModelData =
          await repository.getVehicleInfo(vehicleListRep.first, bearertoken);
      setState(() {
        token = bearertoken;
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
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Make - ${vehicleInfoModelData?.make ?? ''}'),
                    ),
                    ListTile(
                      title:
                          Text('Model - ${vehicleInfoModelData?.model ?? ''}'),
                    ),
                    ListTile(
                      title: Text('Year - ${vehicleInfoModelData?.year ?? ''}'),
                    ),
                  ],
                ),
              )

              // ListView.separated(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.vertical,
              //     itemBuilder: (context, index) {
              //       return Card(
              //         elevation: 3,
              //         child: ListTile(
              //           title: Text(vehicleList[index]),
              //           trailing: const Icon(Icons.navigate_next),
              //           onTap: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => VehicleInfo(
              //                           vehicleId: vehicleList[index],
              //                           accessToken: token,
              //                         )));
              //           },
              //         ),
              //       );
              //     },
              //     separatorBuilder: (context, index) {
              //       return const SizedBox(
              //         height: 10,
              //       );
              //     },
              //     itemCount: vehicleList.length),
              )
        ],
      ),
    );
  }
}
