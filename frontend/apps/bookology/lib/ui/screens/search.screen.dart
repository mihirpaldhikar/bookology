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

import 'package:bookology/constants/values.constants.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 6,
          title: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade200
                  : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(
                ValuesConstant.borderRadius,
              ),
            ),
            margin: const EdgeInsets.only(
              bottom: 5,
            ),
            child: TextField(
              style: TextStyle(
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              controller: _textFieldController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search..',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: 1 == 2
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _textFieldController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 20,
              bottom: 0,
            ),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: const [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.3,
                //   child: _hitsList.isEmpty
                //       ? Center(
                //           child: Text(
                //           'No results',
                //           style: TextStyle(
                //             color: Theme.of(context).primaryColor,
                //           ),
                //         ))
                //       : ListView.builder(
                //           padding: const EdgeInsets.all(4),
                //           itemCount: _hitsList.length,
                //           physics: const BouncingScrollPhysics(),
                //           itemBuilder: (BuildContext context, int index) {
                //             return GestureDetector(
                //               onTap: () {
                //                 DialogsManager(context).showResetPasswordDialog();
                //               },
                //               child: Container(
                //                 margin: const EdgeInsets.only(
                //                   top: 20,
                //                 ),
                //                 padding: const EdgeInsets.all(8),
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(
                //                     ValuesConstant.borderRadius,
                //                   ),
                //                   border: Border.all(
                //                     color: Theme.of(context).primaryColor,
                //                     width: 1,
                //                   ),
                //                 ),
                //                 child: Row(
                //                   children: <Widget>[
                //                     ClipRRect(
                //                       borderRadius: BorderRadius.circular(10),
                //                       child: CachedNetworkImage(
                //                         imageUrl:
                //                             _hitsList[index].bookInformation.name,
                //                         placeholder: (context, url) =>
                //                             const Center(
                //                           child: CircularProgressIndicator(
                //                             valueColor:
                //                                 AlwaysStoppedAnimation<Color>(
                //                               Colors.grey,
                //                             ),
                //                             strokeWidth: 2,
                //                           ),
                //                         ),
                //                         fit: BoxFit.fill,
                //                         height: 70,
                //                         width: 50,
                //                       ),
                //                     ),
                //                     const SizedBox(
                //                       width: 10,
                //                     ),
                //                     Expanded(
                //                       child: Text(
                //                         _hitsList[index]
                //                             .additionalInformation
                //                             .images[0],
                //                         style: TextStyle(
                //                           color: Theme.of(context).primaryColor,
                //                         ),
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //             );
                //           },
                //         ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
