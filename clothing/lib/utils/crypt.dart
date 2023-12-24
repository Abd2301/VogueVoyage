import 'package:crypto/crypto.dart';
import 'dart:convert';

String generateUserIdFromEmail(String email) {
  var bytes = utf8.encode(email); // Encode the email to bytes
  var digest = sha256.convert(bytes); // Hash the bytes using SHA-256
  return digest.toString(); // Convert the hash to a string and use it as the user ID
}
