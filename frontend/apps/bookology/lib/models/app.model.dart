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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['android_package_name'] = this.androidPackageName;
    data['ios_bundle_id'] = this.iosBundleId;
    data['app_version'] = this.appVersion;
    data['app_build_number'] = this.appBuildNumber;
    data['isPublishedOnGooglePlayStore'] = this.isPublishedOnGooglePlayStore;
    data['isPublishedOnAppleAppStore'] = this.isPublishedOnAppleAppStore;
    data['google_play_store_url'] = this.googlePlayStoreUrl;
    data['apple_app_store_url'] = this.appleAppStoreUrl;
    data['direct_update_url'] = this.directUpdateUrl;
    data['changelogs'] = this.changelogs;
    return data;
  }
}
