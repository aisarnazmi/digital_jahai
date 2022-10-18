// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String _baseUrl = kDebugMode
      ? (GetPlatform.isAndroid
          ? 'http://10.0.2.2:8000/api'
          : 'http://127.0.0.1:8000/api')
      : 'https://digital-jahai-backend.000webhostapp.com/api';

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

  put(path, headers, payload) async {
    var url = _baseUrl + path;

    return await http.put(
      Uri.parse(url),
      body: jsonEncode(payload),
      headers: headers,
    );
  }

  delete(path, headers) async {
    var url = _baseUrl + path;

    return await http.delete(
      Uri.parse(url),
      headers: headers,
    );
  }
}
