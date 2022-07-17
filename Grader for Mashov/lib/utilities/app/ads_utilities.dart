// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/custom_dialog.dart';
//
// class AdsUtilities {
//   static NativeAd? nativeAd;
//
//   static Future<void> loadShowNativeAd(VoidCallback onLoaded) async {
//     await NativeAd(
//         adUnitId: Platform.isAndroid
//             ? 'ca-app-pub-8244017869821899/6214755688'
//             : 'ca-app-pub-8244017869821899/4669222804',
//         //adUnitId: NativeAd.testAdUnitId,
//         request: const AdRequest(),
//         factoryId: 'listTile',
//         listener: NativeAdListener(
//           onAdLoaded: (ad) {
//             nativeAd = ad as NativeAd;
//             onLoaded();
//           },
//         )).load();
//   }
//
//   static Future<void> dispose() async {
//     nativeAd!.dispose();
//   }
//
//
//
//   static Widget nativeAdWidget() => nativeAd == null
//       ? const SizedBox()
//       : Container(
//           margin: const EdgeInsets.symmetric(vertical: 10),
//           child: AdWidget(ad: nativeAd!),
//           height: 72.0,
//           alignment: Alignment.center,
//         );
//
// }
