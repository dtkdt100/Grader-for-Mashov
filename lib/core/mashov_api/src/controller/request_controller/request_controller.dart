import 'dart:async';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

///I actually did think this class was gonna be more useful than that.
///But uhm, maybe it will have some meaning in the future??
///Who knows. I'm keeping it.
abstract class RequestController {

  ///create a client
  late http.Client client;

  ///sends a get request.
  Future<http.Response> get(String url, Map<String, String> headers);

  ///sends a post request.
  Future<http.Response> post(String url, Map<String, String> headers, Object body);
}
