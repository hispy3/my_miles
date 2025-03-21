import 'package:flutter/material.dart';
import 'package:my_miles/repository/repository.dart';

import '../constants/colors.dart';
import '../main.dart';
import '../models/vehicle_info_model.dart';
import 'Item_view.dart';

class VehicleInfo extends StatefulWidget {
  final String bearerToken;

  const VehicleInfo({super.key, required this.bearerToken});

  @override
  State<StatefulWidget> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  MyMilesRepository repository = MyMilesRepository();
  bool isLoading = true;
  VehicleInfoModel? vehicleInfoModelData,
      odometerInfoModelData,
      evBatteryLevelInfoModelData,
      evBatteryCapacityInfoModelData,vinInfoModelData;
  var size;

  @override
  void initState() {
    getAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primary,
      body: _getBody(),
    );
  }

  Future<void> getAccessToken() async {
    List<String> vehicleListRep =
        await repository.getVehicleData(widget.bearerToken);
    final response = await Future.wait([
      repository.getVehicleInfo(vehicleListRep.first, widget.bearerToken),
      repository.getOdometerInfo(vehicleListRep.first, widget.bearerToken),
      repository.getEVBatteryLevel(vehicleListRep.first, widget.bearerToken),
      repository.getEVBatteryCapacity(vehicleListRep.first, widget.bearerToken),
      repository.getVin(vehicleListRep.first, widget.bearerToken),
    ]);

    setState(() {
      isLoading = false;
      vehicleInfoModelData = response[0];
      odometerInfoModelData = response[1];
      evBatteryLevelInfoModelData = response[2];
      evBatteryCapacityInfoModelData = response[3];
      vinInfoModelData = response[4];
    });
  }

  Widget _getBody() {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: buttoncolor,
            ),
          )
        : SafeArea(
            child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
                  child: Center(
                    child: Text("Vehicle DashBoard",
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
                    child: Text("Hey, your car is all set!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: mainFontColor,
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    left: 25,
                    right: 25,
                  ),

                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.03),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              vinInfoModelData?.make ?? '',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Make",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: black),
                            ),
                          ],
                        ),
                        Container(
                          width: 0.5,
                          height: 40,
                          color: black.withOpacity(0.3),
                        ),
                        Column(
                          children: [
                            Text(
                              vehicleInfoModelData?.model ?? '',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text("Model",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: black)),
                          ],
                        ),
                        Container(
                          width: 0.5,
                          height: 40,
                          color: black.withOpacity(0.3),
                        ),
                        Column(
                          children: [
                            Text(
                              '${vehicleInfoModelData?.year ?? ''}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Year",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ItemView(
                  title: 'Odometer',
                  value: '${odometerInfoModelData?.distance ?? '0'}km',
                ),
                ItemView(
                  title: 'EV Battery PerCent Remaining',
                  value:
                      '${(evBatteryLevelInfoModelData?.percentRemaining ?? 0) * 100}%',
                ),
                ItemView(
                  title: 'EV Battery Range',
                  value: '${evBatteryLevelInfoModelData?.range ?? '0'}km',
                ),
                ItemView(
                  title: 'EV Battery Capacity',
                  value:
                      '${evBatteryCapacityInfoModelData?.capacity ?? '0'}kWh',
                ),
                Container(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        color: buttoncolor,
                        borderRadius: BorderRadius.circular(25)),
                    child: const Center(
                      child: Text(
                        "Go Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
  }
}
