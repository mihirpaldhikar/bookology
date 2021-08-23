import 'package:after_layout/after_layout.dart';
import 'package:bookology/managers/view.manager.dart';
import 'package:bookology/services/cache.service.dart';
import 'package:bookology/ui/screens/intro.screen.dart';
import 'package:flutter/material.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({Key? key}) : super(key: key);

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager>
    with AfterLayoutMixin<ScreenManager> {
  Future checkFirstSeen() async {
    final CacheService cacheService = new CacheService();
    bool _seen = (cacheService.isIntroScreenSeen());

    if (_seen) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new ViewManager(currentIndex: 0)));
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
