import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  Future<InitializationStatus> initializations;

  AdsService(this.initializations);

  String get nativeAdUnitID => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/2247696110';

  NativeAdListener get nativeAdsListener => NativeAdListener(
        onAdLoaded: (_) {},
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      );
}
