// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:ntbest/data/constants/app_contstants.dart';

// class Ads {
//   Ads._privateConstructor();
//   static final Ads _instance = Ads._privateConstructor();

//   factory Ads() {
//     return _instance;
//   }

//   BannerAd _bannerAd;
//   InterstitialAd myInterstitial;

//   init() {
//     FirebaseAdMob.instance
//         .initialize(appId: AdInfo.bannerId);
//   }

//   BannerAd createBannerAd() {
//     return BannerAd(
//       adUnitId: AdInfo.bannerId,
//       size: AdSize.banner,
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {
//         // print("------------------------------");
//         // print("BannerAd event is $event");
//         // print("------------------------------");
//       },
//     );
//   }

//   void showInterstitial() async {
    
//     try {
//       if ( myInterstitial != null) {
//         await myInterstitial.dispose();
//         myInterstitial = null;
//       }

//       myInterstitial = InterstitialAd(
//         // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//         // https://developers.google.com/admob/android/test-ads
//         // https://developers.google.com/admob/ios/test-ads
//         adUnitId: AdInfo.interstitialAd,
//         //adUnitId: InterstitialAd.testAdUnitId,
//         targetingInfo: targetingInfo,
//         listener: (MobileAdEvent event) async {
//           if ( event == MobileAdEvent.closed )  {
//             await myInterstitial.dispose();
//             myInterstitial = null;
//           }
//         },
//       );

//       myInterstitial
//       ..load()
//       ..show(
//         anchorType: AnchorType.bottom,
//         anchorOffset: 0.0,
//         horizontalCenterOffset: 0.0,
//       );
//     } catch(e) {

//     }
//   }

//   Future<bool> showBanner() async {
//     _bannerAd = createBannerAd()..load();
//     bool isShow = await _bannerAd.show();
//     return isShow;
//   }

//   Future<bool> hideBanner() async {
//     bool isHide = await _bannerAd?.dispose();
//     _bannerAd = null;
//     return isHide;
//   }

//   void dispose() {
//     _bannerAd?.dispose();
//     myInterstitial?.dispose();
//   }

//   // static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//   //   // testDevices: <String>["5729E8A35C13BBBAD9E1DBE06F7B1DE2"],
//   //   keywords: <String>['쇼핑', '인기'],
//   //   //contentUrl: 'http://foo.com/bar.html',
//   //   childDirected: true,
//   //   nonPersonalizedAds: true,
//   // );
//   static const  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     testDevices:  ['E4B200C7136AD0708A2BF1FA76A2E94B',
//                   'C688FB9C0634F2E6FF40ADFF71711FFF',
//                   '70D53A4C46EFEAAA47D76A37CA7499DA',
//                   '5729E8A35C13BBBAD9E1DBE06F7B1DE2',
//                   'E734400E3568F17063613BBF53A2D239'],
//   );
// }
