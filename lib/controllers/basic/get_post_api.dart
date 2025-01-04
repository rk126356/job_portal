import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/basic/toast.dart';

// Generic GET request
Future<Map<String, dynamic>?> getApi({
  required String url,
  bool showPopup = false,
  bool shouldPrint = false,
}) async {
  try {
    final response = await http.get(
      Uri.parse(url),
    );
    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    // Check if the response status code is OK (200)
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (shouldPrint) print(jsonBody);
      // If success is true, return the JSON body
      if (jsonBody['success']) {
        return jsonBody;
      } else {
        // Show the error message if success is false
        if (showPopup) showError(jsonBody['message']);
        return null;
      }
    } else {
      if (showPopup) {
        showError(
            'Failed to load data. Server responded with status: ${response.statusCode}');
      }
      return null;
    }
  } catch (e) {
    if (showPopup) showError('An error occurred: $e');
    return null;
  }
}

// Generic POST request
Future<Map<String, dynamic>?> postApi({
  required String url,
  required Map<String, dynamic> body,
  bool showPopup = false,
  bool shouldPrint = false,
}) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (shouldPrint) {
      print(jsonBody);
      print(response.statusCode);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonBody['success']) {
        if (showPopup) showSuccess(jsonBody['message']);
        return jsonBody;
      }
    } else if (response.statusCode == 409 || response.statusCode == 400) {
      if (showPopup) showError(jsonBody['message']);
      return null;
    } else {
      if (showPopup) {
        showError(
            'Failed to post data. Server responded with status: ${response.statusCode}');
      }
      return null;
    }
  } catch (e) {
    if (showPopup) showError('An error occurred: $e');
    return null;
  }
  return null;
}
