import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/services/app.service.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:bookology/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final List<Widget> _licenses = <Widget>[];
  final Map<String, List> _licenseContent = {};
  bool _loaded = false;
  String appVersion = '';
  String appBuildNumber = '';
  String googlePlayStoreUrl = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final appService = AppService();
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
      tempSubWidget.add(
        const Divider(),
      );
      _licenseContent[license.packages.join(', ')] = tempSubWidget;
    }

    _licenseContent.forEach((key, value) {
      int count = 0;
      for (var element in value) {
        if (element.runtimeType == Divider) count += 1;
      }
      // Replace ExpansionTile with any widget that suits you
      _licenses.add(ExpansionTile(
        title: Text(
          key,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          '$count licenses',
          style: const TextStyle(color: Colors.black),
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
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 20,
          ),
          child: !_loaded
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _licenses.length + 1,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Image(
                            width: 200,
                            height: 200,
                            image: AssetImage(
                              'assets/icons/splash.icon.png',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Version: $appVersion',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Build Number: $appBuildNumber',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 250,
                            child: OutLinedButton(
                              onPressed: () async {
                                launchURL(
                                  url: StringConstants.urlPrivacyPolicy,
                                );
                              },
                              text: StringConstants.wordPrivacyPolicy,
                              icon: Icons.security_outlined,
                              iconColor: Colors.green,
                              textColor: Colors.green,
                              backgroundColor: Colors.green.shade50,
                            ),
                          ),
                          const SizedBox(
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
                              text: StringConstants.wordCheckForUpdates,
                              icon: FontAwesomeIcons.googlePlay,
                              iconColor: Colors.black,
                              textColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
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
                              text: StringConstants.wordSendFeedback,
                              icon: Icons.feedback_outlined,
                              iconColor: Colors.black,
                              textColor: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            StringConstants.sentenceAppNotice,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            StringConstants.appCopyright,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
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
