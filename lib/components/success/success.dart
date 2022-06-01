import 'package:cleaner/components/buttons/primary.dart';
import 'package:cleaner/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  InterstitialAd? _interstitial;

  @override
  void initState() {
    super.initState();

    InterstitialAd.load(
        adUnitId: AdmobUnitInterstitial,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitial = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: SafeArea(
        child: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('All cleaned!', style: theme.textTheme.headline2)),
                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: PrimaryButton(
                    title: 'Go back',
                    press: () {
                      _interstitial?.show();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
