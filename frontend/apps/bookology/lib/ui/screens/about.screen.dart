import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/services/app.service.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:bookology/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LicenseScreen extends StatefulWidget {
  @override
  _LicenseScreenState createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final List<Widget> _licenses = <Widget>[];
  final Map<String, List> _licenseContent = {};
  bool _loaded = false;
  String appVersion = '';
  String appBuildNumber = '';
  String googlePlayStoreUrl = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final appService = new AppService();
    final appInfo = await appService.getAppInfo();
    final remoteAppInfo = await appService.getRemoteAppInfo();
    setState(() {
      appVersion = appInfo.appVersion;
      appBuildNumber = appInfo.appBuildNumber;
      googlePlayStoreUrl = remoteAppInfo.googlePlayStoreUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    _initLicenses();
  }

  Future<void> _initLicenses() async {
    // most of these part are taken from flutter showLicensePage
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      List<Widget> tempSubWidget = [];
      final List<LicenseParagraph> paragraphs =
          await SchedulerBinding.instance!.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
        debugLabel: 'License',
      );
      if (_licenseContent.containsKey(license.packages.join(', '))) {
        tempSubWidget =
            _licenseContent[license.packages.join(', ')] as List<Widget>;
      }
      for (LicenseParagraph paragraph in paragraphs) {
        if (paragraph.indent == LicenseParagraph.centeredIndent) {
          tempSubWidget.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              paragraph.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ));
        } else {
          tempSubWidget.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              paragraph.text,
            ),
          ));
        }
      }
      tempSubWidget.add(Divider());
      _licenseContent[license.packages.join(', ')] = tempSubWidget;
    }

    _licenseContent.forEach((key, value) {
      int count = 0;
      value.forEach((element) {
        if (element.runtimeType == Divider) count += 1;
      });
      // Replace ExpansionTile with any widget that suits you
      _licenses.add(ExpansionTile(
        title: Text('$key', style: TextStyle(color: Colors.black)),
        subtitle: Text(
          '$count licenses',
          style: TextStyle(color: Colors.black),
        ),
        children: <Widget>[...value],
      ));
    });

    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            'About',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 20,
          ),
          child: !_loaded
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _licenses.length + 1,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Image(
                              width: 200,
                              height: 200,
                              image: AssetImage(
                                'assets/icons/splash.icon.png',
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Version: $appVersion',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Build Number: $appBuildNumber',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: 250,
                              child: OutLinedButton(
                                onPressed: () async {
                                  launchURL(
                                    url: StringConstants.APP_PRIVACY_POLICY_URL,
                                  );
                                },
                                text: StringConstants.PRIVACY_POLICY,
                                showText: true,
                                showIcon: true,
                                icon: Icons.security_outlined,
                                iconColor: Colors.green,
                                textColor: Colors.green,
                                outlineColor: Colors.green,
                                backgroundColor: Colors.green.shade50,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 250,
                              child: OutLinedButton(
                                onPressed: () async {
                                  launchURL(
                                    url: googlePlayStoreUrl,
                                  );
                                },
                                text: StringConstants.CHECK_FOR_UPDATED,
                                showText: true,
                                showIcon: true,
                                icon: FontAwesomeIcons.googlePlay,
                                iconColor: Colors.black,
                                textColor: Colors.black,
                                outlineColor: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 250,
                              child: OutLinedButton(
                                onPressed: () async {
                                  launchURL(
                                    url: googlePlayStoreUrl,
                                  );
                                },
                                text: StringConstants.SEND_FEEDBACK,
                                showText: true,
                                showIcon: true,
                                icon: Icons.feedback_outlined,
                                iconColor: Colors.black,
                                textColor: Colors.black,
                                outlineColor: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              StringConstants.APP_NOTICE,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              StringConstants.APP_COPYRIGHT,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Licenses',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return _licenses.elementAt(index - 1);
                  },
                ),
        ),
      ),
    );
  }
}
