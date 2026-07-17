import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MomoService {
  static const String _secretKey = 'sk_test_872a8081e9d415c1e1325734749b63f49e42b7a4';

  static Future<bool> makePayment({
    required String email,
    required int amount,
    required String reference,
  }) async {
    try {
      final url = await _initializeTransaction(
        email: email,
        amount: amount,
        reference: reference,
      );

      if (url == null) return false;

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      return true;
    } catch (e) {
      print('Paystack error: $e');
      return false;
    }
  }

  static Future<String?> _initializeTransaction({
    required String email,
    required int amount,
    required String reference,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/initialize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_secretKey',
        },
        body: jsonEncode({
          'email': email,
          'amount': amount,
          'reference': reference,
          'channels': ['mobile_money'],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['authorization_url'] as String?;
      } else {
        print('Paystack API error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Failed to initialize transaction: $e');
    }
    return null;
  }
}
