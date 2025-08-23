abstract class BaseApiServices {
  Future<dynamic> getGetApiRequest(String url);

  Future<dynamic> getPostApiRequest(
    String url,
    Map<String, dynamic> header,
    Map<String, dynamic> body,
  );

  Future<dynamic> getPutApiRequest(
    String url,
    Map<String, dynamic> header,
    Map<String, dynamic> body,
  );

  Future<dynamic> getDeleteApiRequest(String url);
}
