// services/payment_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_assignment_model.dart';

class PaymentService {
  static const String _baseUrl =
      'http://schoolmanagement.canadacentral.cloudapp.azure.com:5000';

  static Future<List<PaymentAssignment>> fetchPaymentAssignments({
    required List<int> classIds,
    required String academicYear,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Token not found");
    }

    final classIdsParam = classIds.join(',');
    final url =
        Uri.parse('$_baseUrl/api/payments/assignments?class_ids=$classIdsParam&academic_year=$academicYear');

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody['data'];

      return data
          .map((item) => PaymentAssignment.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load payment assignments (${response.statusCode})');
    }
  }
}
