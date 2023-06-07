import 'package:device_info_plus/device_info_plus.dart';
import 'package:vanapp/models/branch_model.dart';
import 'package:vanapp/models/supplier_model.dart';
import 'package:vanapp/utils/constants/constant.dart';

import '../utils/network_service.dart';

class CompanyController {
  Future<List<Branch>> getBranches() async {
    final List result = await loadServerData("Branch/GetAllBranch");

    return result.map((json) => Branch.fromJson(json)).toList();
  }

  Future<String> deviceRegistation(
      {branchId = '1', required String deviceName}) async {
    final deviceId = (await _deviceInfo).id;

    final isRegistered = await Constants.isRegistered;
    late final List result;
    if (isRegistered) {
      result = await loadServerData(
          "Register/WriteDeviceRegistration?branch_id=$branchId&device_unique_id=$deviceId&device_name=$deviceName");
      await Constants().registered(true);
    } else {
      result = await loadServerData(
          "Register/UpdateDeviceRegistration?branch_id=$branchId&device_unique_id=$deviceId&device_name=$deviceName");
    }

    return result.first['systemId'];
  }

  Future<AndroidDeviceInfo> get _deviceInfo async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo;
  }
}
