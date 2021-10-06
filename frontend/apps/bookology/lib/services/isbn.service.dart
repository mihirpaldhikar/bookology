/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is furnished
 *  to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:convert';

import 'package:bookology/managers/secrets.manager.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

class IsbnService {
  final SecretsManager _secretsManager = SecretsManager();
  final client = http.Client();

  IsbnService();

  Future<dynamic> getBookInfo({required String isbn}) async {
    try {
      final String? isbnApiURL = await _secretsManager.getApiUrl();
      final requestURL = Uri.parse('$isbnApiURL/isbn/$isbn.json');
      final response = await http.get(requestURL);
      final data = jsonDecode(response.body);
      return data;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<dynamic> getBookAuthor({required String path}) async {
    try {
      final String? isbnApiURL = await _secretsManager.getApiUrl();
      final authorUri = Uri.parse('$isbnApiURL$path.json');
      final authorResponse = await http.get(authorUri);
      final authorData = jsonDecode(authorResponse.body);
      return authorData['name'];
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
