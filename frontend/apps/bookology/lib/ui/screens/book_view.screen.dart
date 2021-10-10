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
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/managers/currency.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/models/request.model.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/ui/components/page_view_indicator.component.dart';
import 'package:bookology/ui/screens/chat.screen.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BookViewer extends StatefulWidget {
  final BookModel book;
  final String id;

  const BookViewer({
    Key? key,
    required this.book,
    required this.id,
  }) : super(key: key);

  @override
  _BookViewerState createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService =
      FirestoreService(FirebaseFirestore.instance);
  final CacheService _cacheService = CacheService();
  final CurrencyManager _currencyManager = CurrencyManager();
  final AuthService _authService = AuthService(FirebaseAuth.instance);
  RequestModel _requestData = RequestModel(accepted: false, roomId: 'null');
  String _username = 'loading...';
  String _userID = '';
  String _userFirstName = 'loading...';
  String _userLastName = '';
  String _uploadedOn = 'loading...';
  String _location = 'loading...';
  String _userProfilePicture = '';
  String _bookCondition = 'loading...';
  bool _isVerified = false;
  bool _isLoadingCompleted = false;
  int _currentPage = 0;
  String _currencySymbol = '';
  late BannerAd _ad;
  bool _isAdLoaded = false;
  bool _isRequestAccepted = false;
  String _enquireButtonText = 'Enquire';

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      adUnitId: kReleaseMode
          ? 'ca-app-pub-6991839116816523/2352963576'
          : 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(
            () {
              _isAdLoaded = true;
            },
          );
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          throw 'Ad load failed (code=${error.code} message=${error.message})';
        },
      ),
    );
    _ad.load();
    _pageController.addListener(() {
      int next = _pageController.page!.round();

      setState(() {
        _currentPage = next;
      });
    });
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await _getBookInfo();
    if (widget.book.uploaderId != _authService.currentUser()!.uid) {
      _requestData = await _firestoreService.getRequest(
        bookID: widget.book.bookId,
        userID: _authService.currentUser()!.uid,
      );
      setState(() {
        _currencySymbol = _currencyManager.getCurrencySymbol(
          currency: widget.book.pricing.currency,
        );
        _isRequestAccepted = _requestData.accepted;
      });
      if (_isRequestAccepted) {
        setState(() {
          _enquireButtonText = 'Discuss';
        });
      } else {
        setState(() {
          _enquireButtonText = 'Requested';
        });
      }
      if (!await _firestoreService.isRequestExist(bookId: widget.book.bookId)) {
        setState(() {
          _enquireButtonText = 'Enquire';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int saving = int.parse(widget.book.pricing.originalPrice) -
        int.parse(widget.book.pricing.sellingPrice);
    return Hero(
      tag: widget.id,
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            actions: [
              Tooltip(
                message: StringConstants.hintShareBook,
                child: IconButton(
                  onPressed: () {
                    ShareService().shareBook(
                      book: widget.book,
                    );
                  },
                  icon: const Icon(Icons.share_outlined),
                ),
              ),
              Visibility(
                visible:
                    widget.book.uploaderId == _authService.currentUser()!.uid
                        ? true
                        : false,
                child: Tooltip(
                  message: StringConstants.hintEditBook,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ),
              ),
              Visibility(
                visible:
                    widget.book.uploaderId == _authService.currentUser()!.uid
                        ? true
                        : false,
                child: Tooltip(
                  message: StringConstants.hintDeleteBook,
                  child: IconButton(
                    onPressed: () async {
                      DialogsManager(context).showDeleteBookDialog(() async {
                        Navigator.of(context).pop();
                        DialogsManager(context).showProgressDialog(
                          content: 'Deleting',
                          contentColor: Colors.redAccent,
                          progressColor: Colors.redAccent,
                        );
                        final result = await _apiService.deleteBook(
                          bookID: widget.id.contains('@')
                              ? widget.id.split('@')[0]
                              : widget.id,
                        );
                        if (result == true) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ViewManager(screenIndex: 3),
                            ),
                            (_) => false,
                          );
                        }
                        if (result == false) {
                          ToastManager(this.context).showToast(
                            message: 'An Error Occurred!',
                            icon: Icons.error_outline_outlined,
                            iconColor: Colors.white,
                            textColor: Colors.white,
                            backGroundColor: Colors.redAccent,
                          );
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    widget.book.uploaderId != _authService.currentUser()!.uid
                        ? true
                        : false,
                child: Tooltip(
                  message: StringConstants.hintReportBook,
                  child: IconButton(
                    onPressed: () async {},
                    icon: const Icon(
                      Icons.report_outlined,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 550,
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: widget
                                  .book.additionalInformation.images.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool activePage = index == _currentPage;
                                return _imagePager(
                                    active: activePage,
                                    image: widget.book.additionalInformation
                                        .images[index]);
                              }),
                        ),
                        Center(
                          child: PageViewIndicator(
                            length:
                                widget.book.additionalInformation.images.length,
                            currentIndex: _currentPage,
                            currentColor:
                                Theme.of(context).colorScheme.secondary,
                            currentSize: 10,
                            otherSize: 5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                widget.book.bookInformation.name,
                                maxLines: 4,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                '${StringConstants.wordBy} ${widget.book.bookInformation.author}',
                                maxLines: 4,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  const AutoSizeText(
                                    '${StringConstants.wordPrice}:',
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  AutoSizeText(
                                    '$_currencySymbol ${widget.book.pricing.sellingPrice}',
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AutoSizeText(
                                    widget.book.pricing.originalPrice,
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 23,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              AutoSizeText(
                                '${StringConstants.wordYouSave} $_currencySymbol ${saving.toString()}',
                                maxLines: 4,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    _location,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Visibility(
                                visible: widget.book.uploaderId !=
                                        _authService.currentUser()!.uid
                                    ? true
                                    : false,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: OutLinedButton(
                                    text: _enquireButtonText,
                                    textColor: Colors.black,
                                    backgroundColor: _isLoadingCompleted
                                        ? _isRequestAccepted
                                            ? Colors.green[100]
                                            : Colors.orange[100]
                                        : Colors.grey[100],
                                    onPressed: () async {
                                      if (_isLoadingCompleted) {
                                        if (_requestData.roomId == 'null') {
                                          await _apiService
                                              .sendEnquiryNotification(
                                            userID:
                                                _authService.currentUser()!.uid,
                                            receiverID: _userID,
                                            bookId: widget.book.bookId,
                                            userName: _cacheService
                                                .getCurrentUserNameCache(),
                                          );

                                          await _firestoreService.createRequest(
                                            bookID: widget.book.bookId,
                                            userID:
                                                _authService.currentUser()!.uid,
                                          );
                                        }

                                        if (_isRequestAccepted == true) {
                                          final room = await _firestoreService
                                              .getRoomData(
                                            roomId: _requestData.roomId,
                                          );
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                room: room,
                                                roomTitle:
                                                    '$_userFirstName $_userLastName',
                                                userName: _username,
                                                isVerified: _isVerified,
                                                userProfileImage:
                                                    _userProfilePicture,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: widget.book.uploaderId !=
                                        _authService.currentUser()!.uid
                                    ? true
                                    : false,
                                child: const SizedBox(
                                  height: 30,
                                ),
                              ),
                              Visibility(
                                visible: widget.book.uploaderId !=
                                        _authService.currentUser()!.uid
                                    ? true
                                    : false,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: OutLinedButton(
                                      text: StringConstants.wordAddToWishList,
                                      textColor: Colors.black,
                                      backgroundColor: Colors.tealAccent[100],
                                      onPressed: () {}),
                                ),
                              ),
                              Visibility(
                                visible: widget.book.uploaderId !=
                                        _authService.currentUser()!.uid
                                    ? true
                                    : false,
                                child: const SizedBox(
                                  height: 40,
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  AutoSizeText(
                                    StringConstants.wordDescription,
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  right: 20,
                                  top: 20,
                                  bottom: 40,
                                ),
                                child: AutoSizeText(
                                  widget.book.additionalInformation.description,
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
                              const Divider(
                                thickness: 2,
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.auto_stories_outlined,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  AutoSizeText(
                                    StringConstants.wordBookDetails,
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${StringConstants.wordIsbn} :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      widget.book.bookInformation.isbn,
                                      style: GoogleFonts.ibmPlexMono(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 10,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${StringConstants.wordAuthor} :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      widget.book.bookInformation.author,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${StringConstants.wordPublisher} :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      widget.book.bookInformation.publisher,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${StringConstants.wordBookCondition} :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      _bookCondition,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Divider(
                                thickness: 2,
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.account_circle_outlined,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  AutoSizeText(
                                    StringConstants.wordUploadDetails,
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 20,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${StringConstants.wordName} :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '$_userFirstName $_userLastName',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 10,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${StringConstants.wordUsername} :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '@$_username',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Visibility(
                                      visible: _isVerified,
                                      child: const Icon(
                                        Icons.verified,
                                        color: Colors.blue,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      StringConstants.wordUploadedOn,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    AutoSizeText(
                                      _uploadedOn,
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
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _isAdLoaded,
                  child: Container(
                    child: AdWidget(ad: _ad),
                    width: _ad.size.width.toDouble(),
                    height: 72.0,
                    alignment: Alignment.center,
                  ),
                )
              ],
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
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFEEEEEE),
              blurRadius: blur,
              offset: Offset(offset, offset))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => const Center(
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

  Future<String> _getBookInfo() async {
    final bookData = await _apiService.getBookByID(
        bookID: widget.id.contains('@') ? widget.id.split('@')[0] : widget.id);
    setState(() {
      _isLoadingCompleted = true;
      _userID = bookData['uploader']['user_id'];
      _username = bookData['uploader']['username'];
      _bookCondition = bookData['additional_information']['condition'];
      _location = bookData['location'] ?? 'Unknown';
      _uploadedOn = '${bookData['created_on']['date']}';
      _userFirstName = bookData['uploader']['first_name'];
      _userLastName = bookData['uploader']['last_name'];
      _isVerified = bookData['uploader']['verified'];
      _userProfilePicture = bookData['uploader']['profile_picture_url'];
    });

    return bookData['uploader']['user_id'];
  }
}
