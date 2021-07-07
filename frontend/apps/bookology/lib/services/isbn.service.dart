import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class IsbnService {
  final isbnApiURL = dotenv.env['ISBN_API_URI'];
  final client = http.Client();

  IsbnService();

  Future<dynamic> getBookInfo({required String isbn}) async {
    try {
      final requestURL = Uri.parse('$isbnApiURL/isbn/${isbn}.json');
      final response = await http.get(requestURL);
      final data = jsonDecode(response.body);
      return data;
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<dynamic> getBookAuthor({required String path}) async {
    try {
      final authorUri = Uri.parse('$isbnApiURL${path}.json');
      final authorResponse = await http.get(authorUri);
      final authorData = jsonDecode(authorResponse.body);
      return authorData['name'];
    } catch (error) {
      print(error);
      return error;
    }
  }
}
