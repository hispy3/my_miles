import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_strings.dart';
import 'package:flutter_smartcar_auth/flutter_smartcar_auth.dart';
import '../models/vehicle_id_model.dart';
import '../models/vehicle_info_model.dart';

class MyMilesRepository {
  Future<void> myMilesSetup() async {
    await Smartcar.setup(
      configuration: const SmartcarConfig(
        clientId: clientId,
        redirectUri: redirectUri,
        scopes: [
          SmartcarPermission.readVin,
          SmartcarPermission.readVehicleInfo,
          SmartcarPermission.readExtendedVehicleInfo,
          SmartcarPermission.readOdometer,
          SmartcarPermission.readBattery,
          SmartcarPermission.readFuel,
          SmartcarPermission.readCharge,
        ],
        mode: SmartcarMode.test,
      ),
    );
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
    await saveToken(data['access_token']);
    return data['access_token'];
  }

  Future<List<String>> getVehicleData(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.smartcar.com/v2.0/vehicles'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    VehicleIdModel data = VehicleIdModel.fromJson(json.decode(response.body));
    List<String> vehicleIds = data.vehicles ?? [];
    return vehicleIds;
  }

  Future<dynamic> getVehicleInfo(String vehicleId, String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.smartcar.com/v2.0/vehicles/$vehicleId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    VehicleInfoModel data =
        VehicleInfoModel.fromJson(json.decode(response.body));
    return data;
  }

  Future<dynamic> getOdometerInfo(String vehicleId, String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.smartcar.com/v2.0/vehicles/$vehicleId/odometer'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    VehicleInfoModel data =
        VehicleInfoModel.fromJson(json.decode(response.body));
    return data;
  }

  Future<dynamic> getEVBatteryLevel(
      String vehicleId, String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.smartcar.com/v2.0/vehicles/$vehicleId/battery'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    VehicleInfoModel data =
        VehicleInfoModel.fromJson(json.decode(response.body));
    return data;
  }

  Future<dynamic> getEVBatteryCapacity(
      String vehicleId, String accessToken) async {
    final response = await http.get(
      Uri.parse(
          'https://api.smartcar.com/v2.0/vehicles/$vehicleId/battery/capacity'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    VehicleInfoModel data =
        VehicleInfoModel.fromJson(json.decode(response.body));
    return data;
  }

  Future<dynamic> getVin(String vehicleId, String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.smartcar.com/v2.0/vehicles/$vehicleId/vin'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    VehicleInfoModel data =
        VehicleInfoModel.fromJson(json.decode(response.body));
    return data;
  }

  Future<void> saveToken(String token) async {
    // final SecureStorage prefs = SecureStorage();
    // prefs.saveToken(token);
  }

  Future<String?> getToken() async {
    // final SecureStorage prefs = SecureStorage();
    // final String? token = await prefs.getToken();
    // return token;
  }
}
