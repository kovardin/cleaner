import 'package:cleaner/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({
    Key? key,
    this.height = 50,
    this.color = Colors.white,
  }) : super(key: key);

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.white,
      enabled: true,
      child: Container(
        height: height,
        color: color,
        child: AdWidget(
          ad: BannerAd(
            adUnitId: AdmobUnitBanner,
            size: AdSize.largeBanner,
            request: AdRequest(),
            listener: BannerAdListener(
              onAdLoaded: (Ad ad) {
                // disable shimmer
              },
            ),
          )..load(),
        ),
      ),
    );
  }
}
