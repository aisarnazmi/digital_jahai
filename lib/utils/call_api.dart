import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CallApi {
  final String _baseUrl = kDebugMode ? 'http://127.0.0.1:8000/api' : 'https://digital-jahai-backend.000webhostapp.com/api';

  post(path, headers, payload) async {
    var url = _baseUrl + path;

    return await http.post(
      Uri.parse(url),
      body: jsonEncode(payload),
      headers: headers,
    );
  }

  get(path, headers) async {
    var url = _baseUrl + path;

    return await http.get(
      Uri.parse(url),
      headers: headers,
    );
  }
}
