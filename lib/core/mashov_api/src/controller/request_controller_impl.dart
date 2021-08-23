import 'dart:async';
import 'package:http/http.dart' as http;
import 'request_controller.dart';

class RequestControllerImpl implements RequestController {
  RequestControllerImpl();

  http.Client _client = http.Client();

  @override
  void changeClient(){
    _client.close();
    _client = http.Client();
  }

  @override
  Future<http.Response> get(String url, Map<String, String> headers) async {
    return _client.get(Uri.parse(url), headers: headers);
  }

  @override
  Future<http.Response> post(String url, Map<String, String> headers,
      dynamic body) async {
    return _client.post(Uri.parse(url), headers: headers, body: body);
  }
}
