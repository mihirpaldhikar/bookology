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

import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/services/app.service.dart';
import 'package:bookology/ui/widgets/circular_image.widget.dart';
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
  String _appVersion = '';
  String _appBuildNumber = '';
  String _googlePlayStoreUrl = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final appService = AppService();
    final appInfo = await appService.getAppInfo();
    final remoteAppInfo = await appService.getRemoteAppInfo();
    setState(() {
      _appVersion = appInfo.appVersion;
      _appBuildNumber = appInfo.appBuildNumber;
      _googlePlayStoreUrl = remoteAppInfo.googlePlayStoreUrl;
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
                          Image.asset(
                            'assets/icons/splash.icon.png',
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Version: $_appVersion',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Build Number: $_appBuildNumber',
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
                                  url: _googlePlayStoreUrl,
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
                                  url: _googlePlayStoreUrl,
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
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Meet The Team Behind Bookology',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 20,
                              bottom: 20,
                            ),
                            margin: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                ValuesConstant.borderRadius,
                              ),
                            ),
                            child: Column(
                              children: [
                                const CircularImage(
                                  image: 'https://firebasestorage.googleapis.com/v0/b/bookology-dev.appspot.com/o/System%2FTeams%2FMihir%20Paldhikar.jpg?alt=media&token=80456c7c-b880-4420-8971-640bb05ea275',
                                  radius: 100,
                                  outlineColor: Colors.black,
                                  outLineWidth: 2,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Mihir Paldhikar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Founder, Project Leader, Sr. Developer,\nInfrastructure Manager',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  '🙋‍♂️  Hey there! I am Mihir Paldhikar. \n You can connect with me on all social platforms with the user id @imihirpaldhikar',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        launchURL(
                                            url:
                                                'https://instagram.com/imihirpaldhikar');
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.red,
                                        size: 35,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        launchURL(
                                            url:
                                                'https://twitter.com/imihirpaldhikar');
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.twitter,
                                        color: Colors.blue,
                                        size: 35,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        launchURL(
                                            url:
                                                'https://github.com/imihirpaldhikar');
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.github,
                                        color: Colors.black,
                                        size: 35,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        launchURL(
                                            url:
                                                'https://linkedin.com/in/imihirpaldhikar');
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.linkedin,
                                        color: Colors.blue,
                                        size: 35,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 20,
                              bottom: 20,
                            ),
                            margin: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                ValuesConstant.borderRadius,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.person_outline_outlined,
                                  color: Colors.grey,
                                  size: 60,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Nandini Gusani',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Designer',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        launchURL(
                                            url:
                                                'https://instagram.com/imihirpaldhikar');
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.red,
                                        size: 35,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            StringConstants.appCopyright,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            StringConstants.sentenceAppNotice,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
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
