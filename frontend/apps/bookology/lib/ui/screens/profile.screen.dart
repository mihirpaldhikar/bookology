import 'package:bookology/services/api.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String profileImage = '';
  bool isVerified = false;
  int booksListed = 0;
  List books = [];
  final apiService = new ApiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircularImage(
                              image: profileImage,
                              radius: 40,
                            ),
                            Expanded(child: Container()),
                            Column(
                              children: [
                                Text(
                                  booksListed.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                Text('Books'),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Text(books.toString())
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  _fetchUserData() async {
    final data = await apiService.userInfo();
    setState(() {
      _isLoading = false;
      userName = data['username'];
      profileImage = data['profile_picture_url'];
      isVerified = data['verified'];
      books = data['books'] as List;
    });
  }
}
