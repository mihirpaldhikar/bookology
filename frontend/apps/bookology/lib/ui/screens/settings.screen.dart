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
import 'package:bookology/managers/bottom_sheet.manager.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:bookology/managers/toast.manager.dart';
import 'package:bookology/models/settings.model.dart';
import 'package:bookology/services/biomertics.service.dart';
import 'package:bookology/themes/bookology.theme.dart';
import 'package:bookology/ui/components/collapsable_app_bar.component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<BookologyThemeProvider>(context).themeMode;
    List<SettingsModel> appSettings = [
      SettingsModel(
        settingName: 'Theme',
        settingIcon: Icons.dark_mode_outlined,
        settingDescription: theme == ThemeMode.light
            ? 'Always in light theme'
            : theme == ThemeMode.dark
                ? 'Always in dark theme'
                : 'Same as device theme',
        onSettingClicked: () {
          BottomSheetManager(context).showThemeBottomSheet();
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
            ToastManager(context)
                .showErrorToast(message: 'Biometrics are not supported.');
          }
        },
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: CollapsableAppBar(
          title: StringConstants.navigationSettings,
          body: SizedBox(
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 60),
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
                        width: 0.5,
                      ),
                      color: Theme.of(context).cardTheme.color,
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
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(
                                  ValuesConstant.secondaryBorderRadius,
                                ),
                              ),
                              child: Icon(
                                appSettings[index].settingIcon,
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
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
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  appSettings[index].settingDescription,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
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
      ),
    );
  }
}
