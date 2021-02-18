import 'package:admob_flutter/admob_flutter.dart';
import 'package:ntbest/data/constants/app_contstants.dart';

class AdManager {
  AdmobInterstitial interstitialAd;

  void init() {
    interstitialAd = AdmobInterstitial(
      adUnitId: AdInfo.interstitialAd,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) {
          // print("[AdManager] load after closed");
          interstitialAd.load();
        }
        // handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
  }

  void dispose() {
    interstitialAd?.dispose();
  }


  void showFullAd() async {

    if ( await interstitialAd.isLoaded) {
      interstitialAd?.show();
    }
  }
}