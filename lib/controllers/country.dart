import 'dart:convert';

import '../util.dart';
import 'package:http/http.dart' as http;

typedef retornoFuncao = void Function(dynamic);
Future<void> getCountries(retornoFuncao callback) async {


  try {
    var url = '${urlReq}getDoc';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",

      },
    );

    callback(jsonDecode(response.body));

  } catch (e) {
    print("Error getCountries: \n" + e.toString());

  }
}