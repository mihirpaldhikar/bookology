import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/services/auth.service.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/services/location.service.dart';
import 'package:bookology/ui/screens/edit_profile.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final AuthService authService = new AuthService(FirebaseAuth.instance);
  final CacheService cacheService = new CacheService();
  final pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> introPages = [
      PageViewModel(
        titleWidget: Text(
          "Welcome to Bookology!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
          ),
        ),
        bodyWidget: Container(
          child: Text(
            'Find the books you want nearby.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        decoration: pageDecoration,
        image: const Center(
          child: Image(
            image: AssetImage('assets/icons/bookology.icon.png'),
            width: 250,
            height: 250,
          ),
        ),
      ),
      PageViewModel(
        title: "Help Others",
        bodyWidget: Container(
          child: Text(
            'Upload the books you don\'t want anymore and give it to some one in need.',
            textAlign: TextAlign.center,
          ),
        ),
        decoration: pageDecoration,
        image: Center(
          child: SvgPicture.asset(
            'assets/svg/help.svg',
            width: 250,
            height: 250,
          ),
        ),
      ),
      PageViewModel(
        title: "Location based Recommendations",
        bodyWidget: Container(
          child: Text(
            'Bookology uses your approximate location to show you books listed near you.',
            textAlign: TextAlign.center,
          ),
        ),
        decoration: pageDecoration,
        image: Center(
          child: SvgPicture.asset(
            'assets/svg/location.svg',
            width: 250,
            height: 250,
          ),
        ),
      ),
      PageViewModel(
        title: "Complete your Profile",
        bodyWidget: Container(
          child: Text(
            'By completing profile, your are ready to start uploading the books! and other users trusts on your uploaded books. ',
            textAlign: TextAlign.center,
          ),
        ),
        decoration: pageDecoration,
        image: Center(
          child: SvgPicture.asset(
            'assets/svg/profile.svg',
            width: 250,
            height: 250,
          ),
        ),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: ColorsConstant.BACKGROUND_COLOR,
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: false,
          onDone: () => _onIntroEnd(context),
          onChange: (pageIndex) {
            if (pageIndex == 3) {
              getCurrentLocation().then((value) {});
            }
          },
          done: Container(
            width: 250,
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 8,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: ColorsConstant.SECONDARY_COLOR,
              border: Border.all(
                color: Theme.of(context).accentColor,
                width: 1,
              ),
              borderRadius:
                  BorderRadius.circular(ValuesConstant.SECONDARY_BORDER_RADIUS),
            ),
            child: Text('Complete Profile'),
          ),
          next: Container(
            width: 200,
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 8,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius:
                  BorderRadius.circular(ValuesConstant.SECONDARY_BORDER_RADIUS),
            ),
            child: Text('Next'),
          ),
          pages: introPages,
        ),
      ),
    );
  }

  void _onIntroEnd(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userID: authService.currentUser()!.uid,
          profilePicture: authService.currentUser()!.photoURL.toString(),
          userName: authService.currentUser()!.email!.split('@')[0],
          bio: '',
          firstName: '',
          lastName: '',
          isInitialUpdate: true,
        ),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    final currentLocation =
        await LocationService().determinePosition(context: context);
    List<Placemark> placeMarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
  }
}
