import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi {
  final String _url = "https://digital-jahai.000webhostapp.com/api/";

  post(payload, apiUrl) async {
    var fullUrl = _url + apiUrl;

    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(payload),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
