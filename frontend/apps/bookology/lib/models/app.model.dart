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

class AppModel {
  String appName = '';
  String androidPackageName = '';
  String iosBundleId = '';
  String appVersion = '';
  String appBuildNumber = '';
  bool isPublishedOnGooglePlayStore = false;
  bool isPublishedOnAppleAppStore = false;
  String googlePlayStoreUrl = '';
  String appleAppStoreUrl = '';
  String directUpdateUrl = '';
  String changelogs = '';

  AppModel({
    required this.appName,
    required this.androidPackageName,
    required this.iosBundleId,
    required this.appVersion,
    required this.appBuildNumber,
    required this.isPublishedOnGooglePlayStore,
    required this.isPublishedOnAppleAppStore,
    required this.googlePlayStoreUrl,
    required this.appleAppStoreUrl,
    required this.directUpdateUrl,
    required this.changelogs,
  });

  AppModel.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    androidPackageName = json['android_package_name'];
    iosBundleId = json['ios_bundle_id'];
    appVersion = json['app_version'];
    appBuildNumber = json['app_build_number'];
    isPublishedOnGooglePlayStore = json['isPublishedOnGooglePlayStore'];
    isPublishedOnAppleAppStore = json['isPublishedOnAppleAppStore'];
    googlePlayStoreUrl = json['google_play_store_url'];
    appleAppStoreUrl = json['apple_app_store_url'];
    directUpdateUrl = json['direct_update_url'];
    changelogs = json['changelogs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['android_package_name'] = androidPackageName;
    data['ios_bundle_id'] = iosBundleId;
    data['app_version'] = appVersion;
    data['app_build_number'] = appBuildNumber;
    data['isPublishedOnGooglePlayStore'] = isPublishedOnGooglePlayStore;
    data['isPublishedOnAppleAppStore'] = isPublishedOnAppleAppStore;
    data['google_play_store_url'] = googlePlayStoreUrl;
    data['apple_app_store_url'] = appleAppStoreUrl;
    data['direct_update_url'] = directUpdateUrl;
    data['changelogs'] = changelogs;
    return data;
  }
}
