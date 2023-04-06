import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  Constants();
  static const double padding = 20;

  static const double avatarRadius = 45;
  // static const BASE_URL = "https://192.168.43.116:90/";
  // static String BASE_URL = "http://${await _ip}:90/api/";

  static Future<String> get baseURL async =>
      "http://${await ip}:${await port}/api/";

  static Future<String> get userId async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? "0";
  }

  static Future<String> get ip async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ip') ?? "0.0.0.0";
  }

  static Future<String> get port async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('port') ?? "90";
  }

  Future<bool> setIp(String ip) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('ip', ip);
  }

  Future<bool> setPORT(String port) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('port', port);
  }

  static Future<String> get userName async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? "no name";
  }

  static Future<String> get employeeName async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('employee_name') ?? "";
  }

  static Future<String> get employeeId async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('employee_id') ?? "";
  }

  Future<bool> setUserName(String name) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_name', name);
  }

  Future<bool> setUserId(String id) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_id', id);
  }

  Future<bool> setEmployeeName(String name) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('employee_name', name);
  }

  Future<bool> setEmployeeId(String id) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('employee_id', id);
  }
}
