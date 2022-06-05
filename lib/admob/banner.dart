// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdmobBanner {
//   static bool _isLoaded = false;
//   static final BannerAd _myBanner = BannerAd(
//     adUnitId: 'ca-app-pub-8099073799754548/3857358451',
//     size: AdSize.banner,
//     request: const AdRequest(),
//     listener: BannerAdListener(
//       // Called when an ad is successfully received.
//       onAdLoaded: (Ad ad) {
//         _isLoaded = true;
//         print('Ad loaded.');
//       },
//       // Called when an ad request failed.
//       onAdFailedToLoad: (Ad ad, LoadAdError error) {
//         // Dispose the ad here to free resources.
//         ad.dispose();
//         print('Ad failed to load: $error');
//       },
//       // Called when an ad opens an overlay that covers the screen.
//       onAdOpened: (Ad ad) => print('Ad opened.'),
//       // Called when an ad removes an overlay that covers the screen.
//       onAdClosed: (Ad ad) => print('Ad closed.'),
//       // Called when an impression occurs on the ad.
//       onAdImpression: (Ad ad) => print('Ad impression.'),
//     ),
//   );

//   // Future<Widget> widgetBanner() async {
//   //   if (!_isLoaded) await _myBanner.load();
//   //   final AdWidget adWidget = AdWidget(ad: _myBanner);
//   //   //if (!_isLoaded) return SizedBox.shrink();
//   //   return Container(
//   //     alignment: Alignment.center,
//   //     child: adWidget,
//   //     width: _myBanner.size.width.toDouble(),
//   //     height: _myBanner.size.height.toDouble(),
//   //   );
//   // }
// }
