import 'package:flutter_postgres/data/base_api_services.dart';
import 'package:flutter_postgres/data/network_api_services.dart';

class LoginRepository {
  final BaseApiServices _services = NetworkApiServices();
}
