import 'package:flutter/material.dart';
import 'package:my_miles/repository/repository.dart';

class VehicleInfo extends StatefulWidget {
  final String vehicleId, accessToken;

  const VehicleInfo(
      {super.key, required this.vehicleId, required this.accessToken});

  @override
  State<StatefulWidget> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  MyMilesRepository repository = MyMilesRepository();
  dynamic vehicleInfo;

  @override
  void initState() {
    vehicleInfo =
        repository.getVehicleInfo(widget.vehicleId, widget.accessToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Vehicle Info'),
      ),
    );
  }
}
