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
import 'package:bookology/constants/android.constant.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/managers/currency.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/models/book.model.dart';
import 'package:bookology/models/request.model.dart';
import 'package:bookology/platforms/android.platform.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/firestore.service.dart';
import 'package:bookology/services/share.service.dart';
import 'package:bookology/ui/components/page_view_indicator.component.dart';
import 'package:bookology/ui/screens/chat.screen.dart';
import 'package:bookology/ui/widgets/coloured_icon.widget.dart';
import 'package:bookology/ui/widgets/rounded_button.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BookViewer extends StatefulWidget {
  final BookModel book;
  final String id;
  final bool isSaveBook;

  const BookViewer({
    Key? key,
    required this.book,
    required this.id,
    required this.isSaveBook,
  }) : super(key: key);

  @override
  _BookViewerState createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService =
      FirestoreService(FirebaseFirestore.instance);
  final PreferencesManager _cacheService = PreferencesManager();
  final CurrencyManager _currencyManager = CurrencyManager();
  final AuthService _authService = AuthService(FirebaseAuth.instance);
  RequestModel _requestData = RequestModel(accepted: false, roomId: 'null');

  int _currentPage = 0;
  String _currencySymbol = '';
  late BannerAd _ad;
  bool _isAdLoaded = false;
  bool _isRequestAccepted = false;
  bool _isEnquireyButonClicked = false;
  bool _isBookSaved = false;
  String _enquireButtonText = 'Enquire';

  @override
  void initState() {
    super.initState();
    _isBookSaved = widget.isSaveBook;
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
    await AndroidPlatform().showToast(message: "Hello from native toast", duration: Toast.lengthLong);
    if (widget.book.uploader.userId != _authService.currentUser()!.uid) {
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
    return Scaffold(
      body: Hero(
        tag: widget.id,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Tooltip(
                message: StringConstants.hintShareBook,
                child: SizedBox(
                  width: 60,
                  child: IconButton(
                    onPressed: () {
                      ShareService().shareBook(
                        book: widget.book,
                      );
                    },
                    icon: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.book.uploader.userId ==
                        _authService.currentUser()!.uid
                    ? true
                    : false,
                child: Tooltip(
                  message: StringConstants.hintEditBook,
                  child: SizedBox(
                    width: 60,
                    child: IconButton(
                      onPressed: () {
                        ShareService().shareBook(
                          book: widget.book,
                        );
                      },
                      icon: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.book.uploader.userId ==
                        _authService.currentUser()!.uid
                    ? true
                    : false,
                child: Tooltip(
                  message: StringConstants.hintShareBook,
                  child: SizedBox(
                    width: 60,
                    child: IconButton(
                      onPressed: () async {
                        DialogsManager(context).showDeleteBookDialog(() async {
                          Navigator.of(context).pop();
                          DialogsManager(context).showProgressDialog(
                            content: 'Deleting',
                            contentColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .error,
                            progressColor: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .error,
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
                            ToastManager(this.context)
                                .showToast(message: 'An Error Occurred!');
                          }
                        });
                      },
                      icon: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.delete_forever_outlined,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.book.uploader.userId !=
                        _authService.currentUser()!.uid
                    ? true
                    : false,
                child: Tooltip(
                  message: StringConstants.hintEditBook,
                  child: SizedBox(
                    width: 60,
                    child: IconButton(
                      onPressed: () {
                        ShareService().shareBook(
                          book: widget.book,
                        );
                      },
                      icon: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.report_outlined,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
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
                  child: ListView.builder(
                    itemCount: 1,
                    cacheExtent: 9999999999999999999999999.0,
                    semanticChildCount: 1,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 600,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: widget
                                  .book.additionalInformation.images.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool activePage = index == _currentPage;
                                return _imagePager(
                                  active: activePage,
                                  image: widget
                                      .book.additionalInformation.images[index],
                                );
                              },
                            ),
                          ),
                          Center(
                            child: PageViewIndicator(
                              length: widget
                                  .book.additionalInformation.images.length,
                              currentIndex: _currentPage,
                              currentColor:
                                  Theme.of(context).colorScheme.primary,
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    AutoSizeText(
                                      '${StringConstants.wordPrice}:',
                                      maxLines: 4,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 28,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 23,
                                        decoration: TextDecoration.lineThrough,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
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
                                    ColoredIcon(
                                      icon: Icon(
                                        Icons.place_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      margin: const EdgeInsets.only(
                                        right: 10,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.book.location,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: widget.book.uploader.userId !=
                                          _authService.currentUser()!.uid
                                      ? true
                                      : false,
                                  child: const SizedBox(
                                    height: 40,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.book.uploader.userId !=
                                          _authService.currentUser()!.uid
                                      ? true
                                      : false,
                                  child: RoundedButton(
                                      text: _isEnquireyButonClicked
                                          ? 'Requested'
                                          : _enquireButtonText,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      onPressed: () async {
                                        if (_enquireButtonText == 'Enquire') {
                                          DialogsManager(context)
                                              .sendDiscussionRequestDialog(
                                                  onRequestSend: () async {
                                            Navigator.pop(context);
                                            DialogsManager(context)
                                                .showProgressDialog(
                                              content: 'Sending request...',
                                              contentColor: Theme.of(context)
                                                  .primaryColor,
                                              progressColor: Theme.of(context)
                                                  .primaryColor,
                                            );
                                            final isSuccess = await _apiService
                                                .sendEnquiryNotification(
                                              userID: _authService
                                                  .currentUser()!
                                                  .uid,
                                              receiverID:
                                                  widget.book.uploader.userId,
                                              bookId: widget.book.bookId,
                                              userName: _cacheService
                                                  .getCurrentUserNameCache(),
                                            );
                                            setState(() {
                                              _isEnquireyButonClicked = true;
                                              _enquireButtonText = 'Requested';
                                            });
                                            await _firestoreService
                                                .createRequest(
                                              bookID: widget.book.bookId,
                                              userID: _authService
                                                  .currentUser()!
                                                  .uid,
                                            );
                                            if (isSuccess) {
                                              Navigator.pop(context);
                                              ToastManager(context)
                                                  .showToast(
                                                message:
                                                    'Discussions Request Sent',
                                              );
                                            } else {
                                              Navigator.pop(context);
                                              ToastManager(context)
                                                  .showToast(
                                                      message:
                                                          'An error occurred');
                                            }
                                          });
                                        } else {
                                          if (_enquireButtonText != 'Discuss') {
                                            ToastManager(context).showToast(
                                              message: 'Request Already Sent',
                                            );
                                          }
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
                                                    '${widget.book.uploader.firstName} ${widget.book.uploader.lastName}',
                                                userName: widget
                                                    .book.uploader.username,
                                                isVerified: widget
                                                    .book.uploader.verified,
                                                userProfileImage: widget.book
                                                    .uploader.profilePictureUrl,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                ),
                                Visibility(
                                  visible: widget.book.uploader.userId !=
                                          _authService.currentUser()!.uid
                                      ? true
                                      : false,
                                  child: const SizedBox(
                                    height: 30,
                                  ),
                                ),
                                Visibility(
                                  visible: widget.book.uploader.userId !=
                                          _authService.currentUser()!.uid
                                      ? true
                                      : false,
                                  child: RoundedButton(
                                    text: _isBookSaved
                                        ? 'Removed for Saved'
                                        : StringConstants.wordAddToSaved,
                                    outlineWidth: ValuesConstant.outlineWidth,
                                    textColor:
                                        Theme.of(context).colorScheme.primary,
                                    onPressed: () async {
                                      if (_isBookSaved) {
                                        setState(() {
                                          _isBookSaved = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Removed from Saved',
                                            ),
                                            duration: Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                        await _firestoreService
                                            .removedSavedBook(
                                                bookId: widget.book.bookId);
                                      } else {
                                        setState(() {
                                          _isBookSaved = true;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Added to Saved',
                                            ),
                                            duration: Duration(
                                              seconds: 2,
                                            ),
                                          ),
                                        );
                                        await _firestoreService.saveBook(
                                            bookId: widget.book.bookId);
                                      }
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: widget.book.uploader.userId !=
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
                                ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  leading: ColoredIcon(
                                    icon: Icon(
                                      Icons.description_outlined,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    margin: const EdgeInsets.only(
                                      right: 10,
                                    ),
                                  ),
                                  childrenPadding: const EdgeInsets.only(
                                    left: 30,
                                    top: 30,
                                    bottom: 30,
                                  ),
                                  title: AutoSizeText(
                                    StringConstants.wordDescription,
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  children: [
                                    AutoSizeText(
                                      widget.book.additionalInformation
                                          .description,
                                      maxLines: 40,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  leading: ColoredIcon(
                                    icon: Icon(
                                      Icons.auto_stories_outlined,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    margin: const EdgeInsets.only(
                                      right: 10,
                                    ),
                                  ),
                                  title: AutoSizeText(
                                    StringConstants.wordBookDetails,
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  childrenPadding: const EdgeInsets.only(
                                    left: 30,
                                    top: 30,
                                    bottom: 30,
                                  ),
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${StringConstants.wordIsbn} :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${StringConstants.wordAuthor} :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${StringConstants.wordPublisher} :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${StringConstants.wordBookCondition} :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          widget.book.additionalInformation
                                              .condition,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ExpansionTile(
                                  leading: ColoredIcon(
                                    icon: Icon(
                                      Icons.account_circle_outlined,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    margin: const EdgeInsets.only(
                                      right: 10,
                                    ),
                                  ),
                                  tilePadding: EdgeInsets.zero,
                                  title: AutoSizeText(
                                    StringConstants.wordUploadDetails,
                                    maxLines: 4,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  childrenPadding: const EdgeInsets.only(
                                    left: 30,
                                    top: 30,
                                    bottom: 30,
                                  ),
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${StringConstants.wordName} :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '${widget.book.uploader.firstName} ${widget.book.uploader.lastName}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${StringConstants.wordUsername} :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '@${widget.book.uploader.username}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Visibility(
                                          visible:
                                              widget.book.uploader.verified,
                                          child: const Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          StringConstants.wordUploadedOn,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        AutoSizeText(
                                          widget.book.createdOn.date,
                                          maxLines: 4,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1A1919)
                  : const Color(0xFFEEEEEE),
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
}
