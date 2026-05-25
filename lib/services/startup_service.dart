import 'package:flutter/foundation.dart';
import 'package:startapp_sdk/startapp.dart';

class StartAppService {
  static final StartAppSdk sdk = StartAppSdk();

  // ================= INTERSTITIAL =================

  static StartAppInterstitialAd? interstitialAd;

  // ================= REWARDED =================

  static StartAppRewardedVideoAd? rewardedAd;

  // ================= INITIALIZE =================

  static Future<void> initialize() async {
    await sdk.setTestAdsEnabled(false);
    await loadInterstitialAd();
    await loadRewardedAd();
  }

  // ================= INTERSTITIAL =================

  static Future<void> loadInterstitialAd() async {
    try {
      interstitialAd = await sdk.loadInterstitialAd();

      debugPrint("Interstitial Loaded");
    } catch (e) {
      debugPrint("Interstitial load error: $e");
    }
  }

  static Future<void> showInterstitialAd() async {
    if (interstitialAd == null) return;

    try {
      final shown = await interstitialAd!.show();

      if (shown) {
        interstitialAd = null;

        await loadInterstitialAd();
      }
    } catch (e) {
      debugPrint("Interstitial show error: $e");
    }
  }

  // ================= REWARDED =================

  static Future<void> loadRewardedAd() async {
    try {
      rewardedAd = await sdk.loadRewardedVideoAd(
        onVideoCompleted: () {
          debugPrint("Reward completed");
        },
      );

      debugPrint("Rewarded Loaded");
    } catch (e) {
      debugPrint("Rewarded load error: $e");
    }
  }

  static Future<void> showRewardedAd() async {
    if (rewardedAd == null) return;

    try {
      await rewardedAd!.show();

      rewardedAd = null;

      await loadRewardedAd();
    } catch (e) {
      debugPrint("Rewarded show error: $e");
    }
  }

  // ================= BANNER =================

  static Future<StartAppBannerAd?> loadBannerAd() async {
    try {
      final banner = await sdk.loadBannerAd(
        StartAppBannerType.BANNER,
      );

      debugPrint("Banner Loaded");

      return banner;
    } catch (e) {
      debugPrint("Banner load error: $e");

      return null;
    }
  }
}