import 'dart:convert';
import 'dart:io';
import 'package:flutter_postgres/data/api_exception.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/repository/auth_repo/refresh_access_token_repo.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  final TokenStorageService _tokenStorage = TokenStorageService();
  final RefreshAccessTokenRepo _accessTokenRepo = RefreshAccessTokenRepo();
  @override
  Future getGetApiRequest(String url, Map<String, dynamic>? header) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
        ...?header,
      };
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers.map((k, v) => MapEntry(k, v.toString())),
      );

      if (response.statusCode == 401) {
        await _accessTokenRepo.getFreshAccessToken(
          await _tokenStorage.getRefreshToken(),
        );

        final newAccessToken = await _tokenStorage.getAccessToken();

        final retryHeaders = {
          "Content-Type": "application/json",
          if (newAccessToken != null) "Authorization": "Bearer $newAccessToken",
          ...?header,
        };
        final retryResponse = await http.get(
          Uri.parse(url),
          headers: retryHeaders.map((k, v) => MapEntry(k, v.toString())),
        );
        return checkAndReturnApiResponse(retryResponse);
      }
      return checkAndReturnApiResponse(response);
    } on SocketException {
      throw FetchDataException('No internet Connection');
    }
  }

  @override
  Future getPostApiRequest(
    String url,
    Map<String, dynamic> header,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
        ...header,
      };
      final http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 15));

      if (response.statusCode == 401) {
        await _accessTokenRepo.getFreshAccessToken(
          await _tokenStorage.getRefreshToken(),
        );
        final newToken = await _tokenStorage.getAccessToken();

        final retryHeaders = {
          "Content-Type": "application/json",
          if (newToken != null) "Authorization": "Bearer $newToken",
          ...header,
        };

        final retryResponse = await http.post(
          Uri.parse(url),
          headers: retryHeaders.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
          body: jsonEncode(body),
        );
        return checkAndReturnApiResponse(retryResponse);
      }

      return checkAndReturnApiResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  @override
  Future getPutApiRequest(
    String url,
    Map<String, dynamic> header,
    Map<String, dynamic> body,
  ) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
        ...header,
      };

      final http.Response response = await http
          .put(
            Uri.parse(url),
            headers: headers.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 401) {
        await _accessTokenRepo.getFreshAccessToken(
          await _tokenStorage.getRefreshToken(),
        );
        final newToken = await _tokenStorage.getAccessToken();

        final retryHeaders = {
          "Content-Type": "application/json",
          if (newToken != null) "Authorization": "Bearer $newToken",
          ...header,
        };

        final retryResponse = await http.put(
          Uri.parse(url),
          headers: retryHeaders.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
          body: jsonEncode(body),
        );
        return checkAndReturnApiResponse(retryResponse);
      }

      return checkAndReturnApiResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  @override
  Future getDeleteApiRequest(String url) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };
      final http.Response response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 401) {
        await _accessTokenRepo.getFreshAccessToken(
          await _tokenStorage.getRefreshToken(),
        );
        final newToken = await _tokenStorage.getAccessToken();

        final retryHeaders = {
          "Content-Type": "application/json",
          if (newToken != null) "Authorization": "Bearer $newToken",
        };

        final retryResponse = await http.delete(
          Uri.parse(url),
          headers: retryHeaders,
        );
        return checkAndReturnApiResponse(retryResponse);
      }
      return checkAndReturnApiResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  ///  The below print line give the backend-response either bad response or success response
  /// we can debug the backend code with these two line of code
  dynamic checkAndReturnApiResponse(http.Response response) {
    // print("statusCode: ${response.statusCode}");
    // print("Body: ${response.body}");
    // print("Request URl: ${response.request?.url}");
    // print('Request Headers: ${response.request?.headers}');
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
