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

import 'dart:developer';

import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/models/saved_book.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/ui/components/collapsable_app_bar.component.dart';
import 'package:bookology/ui/screens/book_view.screen.dart';
import 'package:bookology/ui/widgets/book_card.widget.dart';
import 'package:bookology/ui/widgets/error.widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final FirestoreService _firestoreService =
      FirestoreService(FirebaseFirestore.instance);
  List<SavedBookModel> _savedBookList = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _firestoreService.getSavedBook().then((value) {
      setState(() {
        _savedBookList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollapsableAppBar(
        automaticallyImplyLeading: true,
        title: 'Saved Books',
        body: FutureBuilder<List<BookModel>?>(
          initialData: const [],
          future: ApiService().getSavedBooks(),
          builder: (BuildContext context,
              AsyncSnapshot<List<BookModel>?> savedBook) {
            if (savedBook.connectionState == ConnectionState.done) {
              if (savedBook.hasError) {
                return const Error(
                  message: 'An Error Occurred!',
                );
              }

              if (savedBook.hasData) {
                log(savedBook.data![0].bookId);
                if (savedBook.data!.length == 1 &&
                    savedBook.data![0].bookId == 'Nil Book ID') {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        'No Saved Books',
                        style: TextStyle(
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: savedBook.data!.length,
                        itemBuilder: (context, index) {
                          return bookList(book: savedBook.data![index]);
                        }),
                  );
                }
              }
            }

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bookList({required BookModel book}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 17,
        right: 17,
        top: 5,
      ),
      child: Slidable(
        secondaryActions: [
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonTheme.colorScheme!.background,
                borderRadius:
                    BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
              ),
              child: Icon(
                Icons.share,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
              ),
            ),
            onTap: () {
              ShareService().shareBook(
                book: book,
              );
            },
          ),
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey.shade400,
                borderRadius:
                    BorderRadius.circular(ValuesConstant.secondaryBorderRadius),
              ),
              child: Icon(
                _savedBookList
                        .where((element) => element.bookId == book.bookId)
                        .isNotEmpty
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey
                    : Colors.grey.shade900,
              ),
            ),
            onTap: () async {
              // if (book.uploader.userId != _authService.currentUser()!.uid) {
              if (_savedBookList
                  .where((element) => element.bookId == book.bookId)
                  .isEmpty) {
                await _firestoreService.saveBook(bookId: book.bookId);
                setState(() {
                  _savedBookList
                      .add(SavedBookModel.fromJson({'bookId': book.bookId}));
                });
              } else {
                await _firestoreService.removedSavedBook(bookId: book.bookId);
                setState(() {
                  _savedBookList
                      .removeWhere((element) => element.bookId == book.bookId);
                });
              }
              //}
            },
          ),
        ],
        actionPane: const SlidableBehindActionPane(),
        child: BookCard(
          showMenu: false,
          id: book.bookId,
          book: book,
          onClicked: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => BookViewer(
                  id: book.bookId,
                  book: book,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
