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

import 'package:bookology/utils/random_string_generator.util.dart';
import 'package:bookology/utils/validator.util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Verifies the if the given email is a valid email or not', () async {
    // Test the valid email
    final emailValidator1 = Validator().validateEmail('testuser@example.com');
    expect(emailValidator1, true);

    // Test the invalid email
    final emailValidator2 = Validator().validateEmail('testuser');
    expect(emailValidator2, false);
  });

  test('Verifies the if the given password is a valid password or not',
      () async {
    // Test the valid password
    final passwordValidator1 =
        Validator().validatePassword('@!THISisATestPassword1234');
    expect(passwordValidator1, true);

    // Test the invalid password
    final passwordValidator2 = Validator().validatePassword('testpassword');
    expect(passwordValidator2, false);
  });

  test('Generate a random string from a given length', () async {
    // Generate a random string
    final randomString = RandomString().generate(20);
    expect(randomString.length, 20);
    expect(randomString.isEmpty, false);
    expect(randomString.isNotEmpty, true);
    expect(randomString.runtimeType, String);
  });
}
