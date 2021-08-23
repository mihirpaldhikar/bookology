import 'package:bookology/constants/colors.constant.dart';
import 'package:bookology/constants/values.constants.dart';
import 'package:bookology/managers/dialogs.managers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';t';

// COMPLETE: Import google_mobile_ads.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeInlineAd extends StatefulWidget {
  NativeInlineAd();

  @override
  State createState() => _NativeInlineAdState();
}

class _NativeInlineAdState extends State<NativeInlineAd>
    with AutomaticKeepAliveClientMixin {
  // COMPLETE: Add NativeAd instance
  late NativeAd _ad;

  // COMPLETE: Add _isAdLoaded
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    // COMPLETE: Create a NativeAd instance
    _ad = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      factoryId: 'bookCardAd',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // COMPLETE: Load an ad
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded) {
      return Container(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 3,
                      bottom: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      borderRadius: BorderRadius.circular(
                          ValuesConstant.SECONDARY_BORDER_RADIUS),
                      border: Border.all(
                        color: Colors.yellow,
                        width: 1,
                      ),
                    ),
                    child: Text('Sponsored'),
                  ),
                  InkWell(
                    onTap: () {
                      DialogsManager(context).showAboutSponsoredDialog();
                    },
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: ColorsConstant.SECONDARY_COLOR,
                        borderRadius: BorderRadius.circular(
                            ValuesConstant.SECONDARY_BORDER_RADIUS),
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.help_outline_outlined,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: 200, child: AdWidget(ad: _ad)),
            ],
          ),
        ),
        height: 270,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1,
              color: Colors.grey,
            )),
        alignment: Alignment.center,
      );
    }
    return Container(
      height: 72.0,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
