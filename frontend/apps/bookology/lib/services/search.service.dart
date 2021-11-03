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

import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

class SearchService {
  final String _apiUrl = "https://search-bookology.azurewebsites.net";
  final _client = http.Client();

  Future<bool> indexBook() async {
    try {
      final requestUrl =
          Uri.parse('$_apiUrl/collections/testing-book-search/documents');
      final request = await _client.post(
        requestUrl,
        headers: {
          "Content-Type": "application/json",
          "X-TYPESENSE-API-KEY": 'fhBt2rcSikzptkCPnNaiY7nG0tPbVn2R2WhuREEH',
        },
        body: jsonEncode({
          "search_id": 1,
          "name": "test_book",
          "isbn": "1234567890",
          "author": "Mihir Paldhikar",
          "publisher": "Mihir P",
          "location": "Jamnagar, Gujarat, India",
          "cover_image": "https://google.com",
          "condition": "good",
          "selling_price": "90",
          "original_price": "9000"
        }),
      );

      if (request.statusCode == 201) {
        return true;
      }

      return false;
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
