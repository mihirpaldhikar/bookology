/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *  the Software, and to permit persons to whom the Software is furnished to do so,
 *  subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 *  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 *  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/ui/components/page_view_indicator.component.dart';
import 'package:bookology/ui/screens/profile_viewer.screen.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookViewer extends StatefulWidget {
  final String bookID;
  final String isbn;
  final String uploaderID;
  final String bookName;
  final String bookAuthor;
  final String bookPublished;
  final String bookDescription;
  final String originalPrice;
  final String sellingPrice;
  final List<String>? images;

  const BookViewer({
    Key? key,
    required this.bookID,
    required this.isbn,
    required this.uploaderID,
    required this.bookName,
    required this.bookAuthor,
    required this.bookPublished,
    required this.bookDescription,
    required this.originalPrice,
    required this.sellingPrice,
    required this.images,
  }) : super(key: key);

  @override
  _BookViewerState createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final ApiService apiService = ApiService();
  final FirestoreService firestoreService =
      FirestoreService(FirebaseFirestore.instance);
  final CacheService cacheService = new CacheService();
  String username = 'loading...';
  String userID = '';
  String userFirstName = 'loading...';
  String userLastName = '';
  String uploadedOn = 'loading...';
  String location = 'loading...';
  String userProfilePicture = '';
  String bookCondition = 'loading...';
  bool isVerified = false;
  bool isLoadingCompleted = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _getBookInfo();
    _pageController.addListener(() {
      int next = _pageController.page!.round();

      if (currentPage != null) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int saving =
        int.parse(widget.originalPrice) - int.parse(widget.sellingPrice);
    final authService = Provider.of<AuthService>(context);
    return Hero(
      tag: widget.bookID,
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            actions: [
              Visibility(
                visible: widget.uploaderID == authService.currentUser()!.uid
                    ? true
                    : false,
                child: Tooltip(
                  message: StringConstants.HINT_EDIT_BOOK,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit_outlined),
                  ),
                ),
              ),
              Visibility(
                visible: widget.uploaderID == authService.currentUser()!.uid
                    ? true
                    : false,
                child: Tooltip(
                  message: StringConstants.HINT_DELETE_BOOK,
                  child: IconButton(
                    onPressed: () async {
                      DialogsManager(context).showDeleteBookDialog(() async {
                        Navigator.of(context).pop();
                        showLoaderDialog(context);
                        final result = await apiService.deleteBook(
                          bookID: widget.bookID.contains('@')
                              ? widget.bookID.split('@')[0]
                              : widget.bookID,
                        );
                        if (result == true) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewManager(currentIndex: 3),
                            ),
                            (_) => false,
                          );
                        }
                      });
                    },
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.uploaderID != authService.currentUser()!.uid
                    ? true
                    : false,
                child: Tooltip(
                  message: StringConstants.HINT_MORE_OPTIONS,
                  child: IconButton(
                    onPressed: () async {},
                    icon: Icon(Icons.more_vert_outlined),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: SizedBox(
                        height: 550,
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.images!.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              bool activePage = index == currentPage;
                              return _imagePager(
                                  active: activePage,
                                  image: widget.images![index]);
                            }),
                      ),
                    ),
                    Center(
                      child: PageViewIndicator(
                        length: widget.images!.length,
                        currentIndex: currentPage,
                        currentColor: Theme.of(context).accentColor,
                        currentSize: 10,
                        otherSize: 5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            widget.bookName,
                            maxLines: 4,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            '${StringConstants.BY} ${widget.bookAuthor}',
                            maxLines: 4,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              AutoSizeText(
                                '${StringConstants.PRICE}:',
                                maxLines: 4,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              AutoSizeText(
                                this.widget.sellingPrice,
                                maxLines: 4,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                this.widget.originalPrice,
                                maxLines: 4,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 23,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            '${StringConstants.YOU_SAVE} ${saving.toString()}',
                            maxLines: 4,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Visibility(
                            visible: widget.uploaderID !=
                                    authService.currentUser()!.uid
                                ? true
                                : false,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: OutLinedButton(
                                showIcon: false,
                                showText: true,
                                text: StringConstants.ENQUIRE,
                                textColor: Colors.black,
                                outlineColor: isLoadingCompleted
                                    ? Colors.orange
                                    : Colors.grey,
                                backgroundColo: isLoadingCompleted
                                    ? Colors.orange[100]
                                    : Colors.grey[100],
                                onPressed: () async {
                                  if (isLoadingCompleted) {
                                    final result =
                                        await firestoreService.getRequest(
                                      bookID: widget.bookID,
                                      userID: userID,
                                    );

                                    if (result == 'empty') {
                                      await apiService.sendEnquiryNotification(
                                        userID: authService.currentUser()!.uid,
                                        receiverID: userID,
                                        userName: cacheService
                                            .getCurrentUserNameCache(),
                                      );

                                      await firestoreService.createRequest(
                                        bookID: widget.bookID,
                                        userID: authService.currentUser()!.uid,
                                      );
                                    }

                                    if (result == true) {}
                                    // final room =
                                    //     await ChatsService().createChatRoom(
                                    //   ownerUserID:
                                    //       authService.currentUser()?.uid,
                                    //   userID: userID,
                                    //   bookName: widget.bookName,
                                    //   bookCoverImage: widget.images![0],
                                    // );
                                    // Navigator.of(context).pop();
                                    // await Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ChatPage(
                                    //       room: room,
                                    //       roomTitle:
                                    //           '$userFirstName $userLastName',
                                    //       userName: username,
                                    //       isVerified: isVerified,
                                    //       userProfileImage: userProfilePicture,
                                    //     ),
                                    //   ),
                                    // );
                                  }
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.uploaderID !=
                                    authService.currentUser()!.uid
                                ? true
                                : false,
                            child: SizedBox(
                              height: 30,
                            ),
                          ),
                          Visibility(
                            visible: widget.uploaderID !=
                                    authService.currentUser()!.uid
                                ? true
                                : false,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: OutLinedButton(
                                  showIcon: false,
                                  showText: true,
                                  text: StringConstants.ADD_TO_WISHLIST,
                                  textColor: Colors.black,
                                  outlineColor: Colors.teal,
                                  backgroundColo: Colors.tealAccent[100],
                                  onPressed: () {}),
                            ),
                          ),
                          Visibility(
                            visible: widget.uploaderID !=
                                    authService.currentUser()!.uid
                                ? true
                                : false,
                            child: SizedBox(
                              height: 40,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                color: Theme.of(context).accentColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${StringConstants.BOOK_LOCATION} : $location',
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          AutoSizeText(
                            StringConstants.DESCRIPTION,
                            maxLines: 4,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 20,
                            ),
                            child: AutoSizeText(
                              widget.bookDescription,
                              maxLines: 40,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          AutoSizeText(
                            StringConstants.BOOK_DETAILS,
                            maxLines: 4,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${StringConstants.ISBN} :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  widget.isbn,
                                  style: GoogleFonts.ibmPlexMono(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${StringConstants.AUTHOR} :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  widget.bookAuthor,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${StringConstants.PUBLISHER} :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  widget.bookPublished,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${StringConstants.BOOK_CONDITION} :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  bookCondition,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          AutoSizeText(
                            StringConstants.UPLOADER_DETAILS,
                            maxLines: 4,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${StringConstants.USERNAME} :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Visibility(
                                  visible: isVerified,
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${StringConstants.NAME} :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '$userFirstName $userLastName',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${StringConstants.UPLOADED_ON} :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                AutoSizeText(
                                  uploadedOn,
                                  maxLines: 4,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: widget.uploaderID !=
                                    authService.currentUser()!.uid
                                ? true
                                : false,
                            child: Center(
                              child: SizedBox(
                                width: 200,
                                child: OutLinedButton(
                                  text: StringConstants.VIEW_PROFILE,
                                  showText: true,
                                  showIcon: false,
                                  textColor: Colors.black,
                                  outlineColor: Colors.black,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileViewer(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePager({required bool active, required String image}) {
    final double blur = active ? 15 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 50 : 100;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0xFFEEEEEE),
              blurRadius: blur,
              offset: Offset(offset, offset))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.grey,
              ),
              strokeWidth: 2,
            ),
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _getBookInfo() async {
    final bookData = await apiService.getBookByID(
        bookID: widget.bookID.contains('@')
            ? widget.bookID.split('@')[0]
            : widget.bookID);
    setState(() {
      isLoadingCompleted = true;
      userID = bookData['uploader']['user_id'];
      username = bookData['uploader']['username'];
      bookCondition = bookData['additional_information']['condition'];
      location =
          bookData['location'] == null ? 'Unknown' : bookData['location'];
      uploadedOn =
          '${bookData['created_on']['date']} \nat ${bookData['created_on']['time']}';
      userFirstName = bookData['uploader']['first_name'];
      userLastName = bookData['uploader']['last_name'];
      isVerified = bookData['uploader']['verified'];
      userProfilePicture = bookData['uploader']['profile_picture_url'];
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.redAccent,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(StringConstants.DIALOG_DELETING)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
