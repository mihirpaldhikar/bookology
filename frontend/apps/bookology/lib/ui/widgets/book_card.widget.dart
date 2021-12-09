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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/managers/currency.manager.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String id;
  final BookModel book;
  final bool? showMenu;
  final VoidCallback onClicked;

  const BookCard({
    Key? key,
    required this.id,
    required this.book,
    required this.onClicked,
    this.showMenu = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int saving = int.parse(book.pricing.originalPrice) -
        int.parse(book.pricing.sellingPrice);

    String currencySymbol =
        CurrencyManager().getCurrencySymbol(currency: book.pricing.currency);

    return Hero(
      tag: id,
      child: Card(
        child: InkWell(
          borderRadius:
              BorderRadius.circular(ValuesConstant.buttonBorderRadius),
          onTap: onClicked,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularImage(
                      image: book.uploader.profilePictureUrl,
                      radius: 30,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      book.uploader.username,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      visible: book.uploader.verified,
                      child: const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 17,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        maxHeightDiskCache: 9999999999,
                        maxWidthDiskCache: 999999999,
                        memCacheHeight: 9999999,
                        memCacheWidth: 999999,
                        imageUrl: book.additionalInformation.images.first,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey,
                            ),
                            strokeWidth: ValuesConstant.outlineWidth,
                          ),
                        ),
                        fit: BoxFit.fill,
                        height: MediaQuery.of(context).size.height * 0.26,
                        width: 150,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        maxHeightDiskCache: 9999999999,
                        maxWidthDiskCache: 999999999,
                        memCacheHeight: 9999999,
                        memCacheWidth: 999999,
                        imageUrl: book.additionalInformation.images.last,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey,
                            ),
                            strokeWidth: 2,
                          ),
                        ),
                        fit: BoxFit.fill,
                        height: MediaQuery.of(context).size.height * 0.26,
                        width: 150,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                AutoSizeText(
                  book.bookInformation.name,
                  maxLines: 4,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    AutoSizeText(
                      'Price:',
                      maxLines: 4,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    AutoSizeText(
                      '$currencySymbol ${book.pricing.sellingPrice}',
                      maxLines: 4,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    AutoSizeText(
                      book.pricing.originalPrice,
                      maxLines: 4,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        decoration: TextDecoration.lineThrough,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                AutoSizeText(
                  'You Save $currencySymbol ${saving.toString()}',
                  maxLines: 4,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
