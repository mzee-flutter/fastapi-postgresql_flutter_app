import 'dart:convert';
import 'dart:io';
import 'package:flutter_postgres/data/api_exception.dart';
import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/view_model/token_storage_service/token_storage_service.dart';
import 'package:flutter_postgres/repository/auth_repo/refresh_access_token_repo.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  final TokenStorageService _tokenStorage = TokenStorageService();
  late final RefreshAccessTokenRepo _refreshRepo;

  NetworkApiServices() {
    _refreshRepo = RefreshAccessTokenRepo(this);
  }

  @override
  Future getGetApiRequest(String url, Map<String, dynamic>? header) async {
    final response = await _sendWithRetry(
      (headers) => http.get(Uri.parse(url), headers: {...headers, ...?header}),
    );
    return _checkResponse(response);
  }

  @override
  Future getPostApiRequest(
    String url,
    Map<String, dynamic> header,
    Map<String, dynamic> body,
  ) async {
    final response = await _sendWithRetry(
      (headers) => http.post(
        Uri.parse(url),
        headers: {...headers, ...header},
        body: jsonEncode(body),
      ),
    );
    return _checkResponse(response);
  }

  @override
  Future getPutApiRequest(
    String url,
    Map<String, dynamic> header,
    Map<String, dynamic> body,
  ) async {
    final response = await _sendWithRetry(
      (headers) => http.put(
        Uri.parse(url),
        headers: {...headers, ...header},
        body: jsonEncode(body),
      ),
    );
    return _checkResponse(response);
  }

  @override
  Future getDeleteApiRequest(String url) async {
    final response = await _sendWithRetry(
      (headers) => http.delete(Uri.parse(url), headers: headers),
    );
    return _checkResponse(response);
  }

  dynamic _checkResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);

      case 400:
        throw BadRequestException("Bad request");

      case 401:
      case 403:
        throw UnauthorizedRequestException("Unauthorized");

      case 500:
      default:
        throw FetchDataException("Error occurred: ${response.statusCode}");
    }
  }

  Future<http.Response> _sendWithRetry(
    Future<http.Response> Function(Map<String, String>) requestFn,
  ) async {
    try {
      // 1️⃣ Get access token
      final token = await _tokenStorage.getAccessToken();
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      // 2️⃣ First attempt
      var response = await requestFn(headers);

      // 3️⃣ If unauthorized → refresh + retry once
      if (response.statusCode == 401) {
        await _refreshRepo.getFreshAccessToken(
          await _tokenStorage.getRefreshToken(),
        );
        final newToken = await _tokenStorage.getAccessToken();

        final retryHeaders = {
          "Content-Type": "application/json",
          if (newToken != null) "Authorization": "Bearer $newToken",
        };

        response = await requestFn(retryHeaders);
      }

      return response;
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }
}
