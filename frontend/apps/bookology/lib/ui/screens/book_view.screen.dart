import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookology/services/api.service.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/ui/components/page_view_indicator.component.dart';
import 'package:bookology/ui/screens/profile_viewer.screen.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookViewer extends StatefulWidget {
  final String bookID;
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
  String username = 'loading...';
  String displayName = 'loading...';
  String uploadedOn = 'loading...';
  String location = 'loading...';
  String bookCondition = 'loading...';
  bool isVerified = false;
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
            title: Text('Book'),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            actions: [
              Visibility(
                visible: widget.uploaderID == authService.currentUser()!.uid
                    ? true
                    : false,
                child: Tooltip(
                  message: 'Edit Book',
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
                  message: 'Delete Book',
                  child: IconButton(
                    onPressed: () async {
                      showLoaderDialog(context);
                      final result = await apiService.deleteBook(
                        bookID: widget.bookID.contains('@')
                            ? widget.bookID.split('@')[0]
                            : widget.bookID,
                      );
                      if (result == true) {
                        Navigator.pushReplacementNamed(context, '/profile');
                      }
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
                  message: 'More Options',
                  child: IconButton(
                    onPressed: () {},
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            'By ${widget.bookAuthor}',
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
                                'Price:',
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
                            'You Save ${saving.toString()}',
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
                                  child: Center(
                                    child: Text(
                                      'Enquire',
                                    ),
                                  ),
                                  outlineColor: Colors.orange,
                                  backgroundColor: Colors.orange[100],
                                  onPressed: () {}),
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
                                  child: Center(
                                    child: Text(
                                      'Add to Wish List',
                                    ),
                                  ),
                                  outlineColor: Colors.teal,
                                  backgroundColor: Colors.tealAccent[100],
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
                                'Book Location : $location',
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
                            'Description',
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
                            'Book Details',
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
                                  'ISBN :',
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
                                  '27201234567',
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
                                  'Author :',
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
                                  'Publisher :',
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
                                  'Book Condition :',
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
                            'Uploader Details',
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
                                  'Username :',
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
                                  'Name :',
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
                                  displayName,
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
                                  'Uploaded On :',
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
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: OutLinedButton(
                                outlineColor: Theme.of(context).accentColor,
                                backgroundColor: Colors.deepPurple[50],
                                child: Center(
                                  child: Text(
                                    'View Profile',
                                  ),
                                ),
                                onPressed: () {
                                  print('the username is $username');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileViewer(),
                                    ),
                                  );
                                },
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
      username = bookData['uploader']['username'];
      bookCondition = bookData['additional_information']['condition'];
      location =
          bookData['location'] == null ? 'Unknown' : bookData['location'];
      uploadedOn =
          '${bookData['created_on']['date']} \nat ${bookData['created_on']['time']}';
      displayName =
          '${bookData['uploader']['first_name']} ${bookData['uploader']['last_name']}';
      isVerified = bookData['uploader']['verified'];
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
              margin: EdgeInsets.only(left: 7), child: Text("Deleting...")),
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
