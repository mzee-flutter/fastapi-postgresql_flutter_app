import 'dart:convert';
import 'dart:io';
import 'package:flutter_postgres/data/api_exception.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiRequest(String url) async {
    dynamic apiResponse;
    try {
      final http.Response response = await http.get(Uri.parse(url));
      apiResponse = checkAndReturnApiResponse(response);
    } on SocketException {
      throw FetchDataException('No internet Connection');
    }
    return apiResponse;
  }

  @override
  Future getPostApiRequest(
    String url,
    Map<String, dynamic> header,
    Map<String, dynamic> body,
  ) async {
    dynamic apiResponse;
    try {
      final http.Response response = await http
          .post(
            Uri.parse(url),
            headers: header.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 15));

      apiResponse = checkAndReturnApiResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return apiResponse;
  }

  @override
  Future getPutApiRequest(
    String url,
    Map<String, dynamic> header,
    Map<String, dynamic> body,
  ) async {
    dynamic apiResponse;
    try {
      final http.Response response = await http
          .put(
            Uri.parse(url),
            headers: header.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 15));

      apiResponse = checkAndReturnApiResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return apiResponse;
  }

  @override
  Future getDeleteApiRequest(String url) async {
    dynamic apiResponse;
    try {
      final http.Response response = await http
          .delete(Uri.parse(url))
          .timeout(Duration(seconds: 15));
      apiResponse = checkAndReturnApiResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return apiResponse;
  }

  dynamic checkAndReturnApiResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic jsonResponse = jsonDecode(response.body);
        return jsonResponse;

      case 400:
        throw BadRequestException('Bad request to the server');

      case 401:
      case 403:
        throw UnauthorizedRequestException(
          'Un-authorized request with statusCode:${response.statusCode}',
        );
      case 500:
      default:
        throw FetchDataException('Exception during data fetching');
    }
  }
}
