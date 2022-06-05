// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdmobInterstitial {
//   static InterstitialAd? _interstitialAd;
//   static bool isShowed = false;

//   static Future loadAd() async {
//     await InterstitialAd.load(
//         adUnitId: 'ca-app-pub-8099073799754548/4743381942',
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             // Keep a reference to the ad so you can show it later.
//             isShowed = false;
//             _interstitialAd = ad;
//             _interstitialAd?.show().then((value) => isShowed = true);
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('InterstitialAd failed to load: $error');
//           },
//         ));
//   }

//   // Future showInterstitialAd() async {
//   //   if (_interstitialAd == null) loadAd();
//   // }

// }
