import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';

class ApiClient {
  final String baseUrl = 'http://3.17.187.184:8000';

  Future<dynamic> post(String endpoint, dynamic body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('📤 POST $url');
    print('📦 Body: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('📥 Status: ${response.statusCode}');
    print('📄 Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw ApiException('Failed: ${response.statusCode} - ${response.body}');
    }
  }


}