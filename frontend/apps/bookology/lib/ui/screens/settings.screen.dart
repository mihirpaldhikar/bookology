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

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/strings.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/managers/app.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/models/settings.model.dart';
import 'package:bookology/services/biomertics.service.dart';
import 'package:bookology/ui/components/animated_dialog.component.dart';
import 'package:bookology/ui/widgets/outlined_button.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final AdaptiveThemeMode themeMode;

  const SettingsScreen({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
        builder: (_, mode, child) {
          AdaptiveThemeMode? _theme = mode as AdaptiveThemeMode?;
          List<SettingsModel> appSettings = [
            SettingsModel(
              settingName: 'Theme',
              settingIcon: Icons.dark_mode_outlined,
              settingDescription: mode == AdaptiveThemeMode.light
                  ? 'Always in light theme'
                  : mode == AdaptiveThemeMode.dark
                      ? 'Always in dark theme'
                      : 'Same as device theme',
              onSettingClicked: () {
                showDialog(
                  context: context,
                  builder: (context) => AnimatedDialog(
                    title: 'Theme',
                    content: [
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'Always in light theme',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                leading: Radio<AdaptiveThemeMode>(
                                  value: AdaptiveThemeMode.light,
                                  groupValue: _theme,
                                  onChanged: (AdaptiveThemeMode? value) {
                                    setState(() {
                                      _theme = value!;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Always in dark theme',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                leading: Radio<AdaptiveThemeMode>(
                                  value: AdaptiveThemeMode.dark,
                                  groupValue: _theme,
                                  onChanged: (AdaptiveThemeMode? value) {
                                    setState(() {
                                      _theme = value!;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Same as device theme',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                leading: Radio<AdaptiveThemeMode>(
                                  value: AdaptiveThemeMode.system,
                                  groupValue: _theme,
                                  onChanged: (AdaptiveThemeMode? value) {
                                    setState(() {
                                      _theme = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    actions: [
                      OutLinedButton(
                        text: 'Save',
                        backgroundColor: Colors.green.shade100,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await AdaptiveTheme.of(context).reset();
                          if (_theme == AdaptiveThemeMode.light) {
                            AdaptiveTheme.of(context).setLight();
                            await AdaptiveTheme.of(context).persist();
                            //RestartWidget.restartApp(context);
                          }
                          if (_theme == AdaptiveThemeMode.dark) {
                            AdaptiveTheme.of(context).setDark();
                            await AdaptiveTheme.of(context).persist();
                            //RestartWidget.restartApp(context);
                          }
                          if (_theme == AdaptiveThemeMode.system) {
                            AdaptiveTheme.of(context).setSystem();
                            await AdaptiveTheme.of(context).persist();
                            RestartWidget.restartApp(context);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      OutLinedButton(
                        text: 'Cancel',
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    dialogIcon: const Icon(
                      Icons.dark_mode_outlined,
                    ),
                  ),
                );
              },
            ),
            SettingsModel(
              settingName: 'Biometrics',
              settingIcon: Icons.fingerprint_outlined,
              settingDescription: 'Authenticate with the biometrics',
              onSettingClicked: () async {
                if (await BiometricsService(context).isBiometricsAvailable()) {
                  DialogsManager(context).showBiometricsSelectionDialog();
                } else {
                  ToastManager(context).showToast(
                    message: 'Biometrics are not supported.',
                    backGroundColor: ColorsConstant.dangerBackgroundColor,
                    textColor: Theme.of(context).primaryColor,
                    iconColor: Theme.of(context).primaryColor,
                    icon: Icons.error_outline_outlined,
                  );
                }
              },
            ),
          ];
          return Scaffold(
            appBar: AppBar(
              title: const Text(StringConstants.navigationSettings),
            ),
            body: SafeArea(
              child: SizedBox(
                child: ListView.builder(
                    padding: const EdgeInsets.only(top: 30),
                    physics: const BouncingScrollPhysics(),
                    itemCount: appSettings.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 30,
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            ValuesConstant.borderRadius,
                          ),
                          onTap: appSettings[index].onSettingClicked,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 15,
                              bottom: 10,
                              top: 10,
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .background,
                                    borderRadius: BorderRadius.circular(
                                      ValuesConstant.secondaryBorderRadius,
                                    ),
                                  ),
                                  child: Icon(
                                    appSettings[index].settingIcon,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appSettings[index].settingName,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      appSettings[index].settingDescription,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
        });
  }
}
