import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PaystackService {
  PaystackService._();

  static const String _secretKey =
      'sk_live_REPLACED';
  static const String _publicKey =
      'pk_live_77d1360609ce17d3a199acdf43ffcd8e35605ef8';

  static String get publicKey => _publicKey;

  static String generateReference() {
    return 'susu_${const Uuid().v4().replaceAll('-', '')}';
  }

  static Future<Map<String, dynamic>?> createTransferRecipient({
    required String name,
    required String accountNumber,
    required String bankCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.paystack.co/transferrecipient'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_secretKey',
        },
        body: jsonEncode({
          'type': 'mobile_money',
          'name': name,
          'account_number': accountNumber,
          'bank_code': bankCode,
          'currency': 'GHS',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      dev.log('Paystack create recipient error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> initiateTransfer({
    required int amountInPesewas,
    required String recipientCode,
    required String reason,
    required String reference,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.paystack.co/transfer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_secretKey',
        },
        body: jsonEncode({
          'source': 'balance',
          'amount': amountInPesewas,
          'recipient': recipientCode,
          'reason': reason,
          'reference': reference,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      dev.log('Paystack initiate transfer error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> verifyTransaction({
    required String reference,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.paystack.co/transaction/verify/$reference'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      dev.log('Paystack verify error: $e');
      return null;
    }
  }

  static Future<String?> initializeTransaction({
    required String email,
    required int amountInPesewas,
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
          'amount': amountInPesewas,
          'reference': reference,
          'currency': 'GHS',
          'channels': ['mobile_money', 'card'],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['authorization_url'] as String?;
      } else {
        final data = jsonDecode(response.body);
        throw PaystackException(
          data['message'] ?? 'Failed to initialize transaction',
        );
      }
    } catch (e) {
      if (e is PaystackException) rethrow;
      throw PaystackException('Network error: $e');
    }
  }
}

class PaystackException implements Exception {
  final String message;
  const PaystackException(this.message);

  @override
  String toString() => message;
}
