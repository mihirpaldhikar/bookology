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

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/services/dynamic_link.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareBook({
    required BuildContext context,
    required BookModel book,
  }) async {
    final dynamicLink =
        await DynamicLinkService().generateDynamicLink(bookId: book.bookId);
    Share.share(
      'Checkout ${book.bookInformation.name} By ${book.bookInformation.author} on ${StringConstants.appName}. \n$dynamicLink',
      subject:
          'Checkout ${book.bookInformation.name} By ${book.bookInformation.author} on ${StringConstants.appName}.',
    );
  }
}
