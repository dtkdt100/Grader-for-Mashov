import 'dart:async';
import 'package:http/http.dart' as http;
import 'request_controller.dart';

class RequestControllerImpl implements RequestController {
  RequestControllerImpl();

  @override
  Future<http.Response> get(String url, Map<String, String> headers) async {
    return client.get(Uri.parse(url), headers: headers);
  }

  @override
  Future<http.Response> post(String url, Map<String, String> headers,
      Object body) async {
    return client.post(Uri.parse(url), headers: headers, body: body);
  }

  @override
  http.Client client = http.Client();

}
