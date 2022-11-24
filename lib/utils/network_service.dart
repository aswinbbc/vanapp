import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/utils/constants/constant.dart';

const Map<String, dynamic> temp = {};

Future getData(String url,
    {Map<String, dynamic> params = temp, post = false}) async {
  final http.Response result;
  if (kDebugMode) {
    print("${await Constants.BASE_URL}$url");
  }
  if (post) {
    result = await http.post(Uri.parse("${await Constants.BASE_URL}$url"),
        body: params); //https://hosted_url.com/login_api
  } else {
    result = await http.get(Uri.parse("${await Constants.BASE_URL}$url"));
  }
  print({'url :', result.request!.url});
  if (kDebugMode) {
    print(result.statusCode);
  }
  if (result.statusCode == 200) {
    final data = result.body;

    if (kDebugMode) {
      print(data);
    }
    return jsonDecode(data);
  }
}
