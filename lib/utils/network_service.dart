import 'dart:convert';
import 'package:http/http.dart' as http;
import '/utils/constants/constant.dart';

const Map<String, dynamic> temp = {};

Future loadServerData(String url,
    {Map<String, dynamic> params = temp, post = false}) async {
  final http.Response result;

  if (post) {
    result = await http.post(Uri.parse("${await Constants.BASE_URL}$url"),
        body: params); //https://hosted_url.com/login_api
  } else {
    result = await http.get(Uri.parse("${await Constants.BASE_URL}$url"));
  }
  if (result.statusCode == 200) {
    final data = result.body;

    return jsonDecode(data);
  }
}
