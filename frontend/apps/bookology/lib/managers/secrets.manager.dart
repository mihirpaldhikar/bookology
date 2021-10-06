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

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecretsManager {
  final FlutterSecureStorage secret = const FlutterSecureStorage();
  final apiURL = dotenv.env['API_URL'];
  final isbnApiURL = dotenv.env['ISBN_API_URL'];
  final apiKEY = dotenv.env['API_KEY'];

  Future<void> setApiKey() async {
    final String apiKey = apiKEY!;
    await secret.write(
      key: 'API_KEY',
      value: apiKey,
    );
  }

  Future<void> setApiUrl() async {
    final String apiUrl = apiURL!;
    await secret.write(
      key: 'API_URL',
      value: apiUrl,
    );
  }

  Future<void> setISBNApiUrl() async {
    final String apiISBNUrl = isbnApiURL!;
    await secret.write(
      key: 'ISBN_API_URL',
      value: apiISBNUrl,
    );
  }

  Future<String?> getApiKey() async {
    return await secret.read(key: 'API_KEY');
  }

  Future<String?> getApiUrl() async {
    return await secret.read(key: 'API_URL');
  }

  Future<String?> getISBNApiUrl() async {
    return await secret.read(key: 'ISBN_API_URL');
  }

  Future<void> removeAllSecrets() async {
    await secret.deleteAll();
  }
}
