import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService extends ChangeNotifier {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  static const String _premiumKey = 'isPremium';
  static const String _premiumProductId = 'premium_monthly';

  // IDs dos anúncios (use IDs de teste durante desenvolvimento)
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String _interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID

  // Inicializar serviço
  Future<void> initialize() async {
    await _loadPremiumStatus();
    await _initializeAds();
    await _initializeInAppPurchases();
  }

  // Carregar status premium
  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_premiumKey) ?? false;
    notifyListeners();
  }

  // Salvar status premium
  Future<void> _savePremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, isPremium);
    _isPremium = isPremium;
    notifyListeners();
  }

  // Inicializar anúncios
  Future<void> _initializeAds() async {
    if (!_isPremium) {
      await MobileAds.instance.initialize();
      _loadBannerAd();
      _loadInterstitialAd();
      _loadRewardedAd();
    }
  }

  // Carregar banner ad
  void _loadBannerAd() {
    if (_isPremium) return;

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  // Carregar interstitial ad
  void _loadInterstitialAd() {
    if (_isPremium) return;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  // Carregar rewarded ad
  void _loadRewardedAd() {
    if (_isPremium) return;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          print('Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  // Mostrar banner ad
  Widget? getBannerAdWidget() {
    if (_isPremium || _bannerAd == null) return null;
    
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  // Mostrar interstitial ad
  Future<void> showInterstitialAd() async {
    if (_isPremium || _interstitialAd == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadInterstitialAd();
      },
    );

    await _interstitialAd!.show();
  }

  // Mostrar rewarded ad
  Future<bool> showRewardedAd() async {
    if (_isPremium || _rewardedAd == null) return false;

    bool rewarded = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewardedAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
        print('User earned reward: ${reward.amount} ${reward.type}');
      },
    );

    return rewarded;
  }

  // Inicializar compras in-app
  Future<void> _initializeInAppPurchases() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      print('In-app purchases not available');
      return;
    }

    // Escutar mudanças nas compras
    InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () {},
      onError: (error) {
        print('Purchase stream error: $error');
      },
    );
  }

  // Processar atualizações de compra
  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        if (purchaseDetails.productID == _premiumProductId) {
          _savePremiumStatus(true);
          _disposeBannerAd();
        }
      }
      
      if (purchaseDetails.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  // Comprar premium
  Future<bool> purchasePremium() async {
    try {
      final ProductDetailsResponse response = await InAppPurchase.instance
          .queryProductDetails({_premiumProductId});

      if (response.notFoundIDs.isNotEmpty) {
        print('Product not found: ${response.notFoundIDs}');
        return false;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      return true;
    } catch (e) {
      print('Error purchasing premium: $e');
      return false;
    }
  }

  // Restaurar compras
  Future<void> restorePurchases() async {
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      print('Error restoring purchases: $e');
    }
  }

  // Obter informações do produto premium
  Future<ProductDetails?> getPremiumProductDetails() async {
    try {
      final ProductDetailsResponse response = await InAppPurchase.instance
          .queryProductDetails({_premiumProductId});

      if (response.productDetails.isNotEmpty) {
        return response.productDetails.first;
      }
    } catch (e) {
      print('Error getting product details: $e');
    }
    return null;
  }

  // Limpar anúncios
  void _disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  // Limpar recursos
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  // Verificar se deve mostrar anúncio
  bool shouldShowAd() {
    return !_isPremium;
  }

  // Obter benefícios premium
  List<String> getPremiumBenefits() {
    return [
      'Sem anúncios',
      'Análises avançadas',
      'Limpeza automática',
      'Relatórios detalhados',
      'Suporte prioritário',
      'Backup na nuvem',
      'Temas personalizados',
      'Otimizações avançadas',
    ];
  }

  // Simular compra premium (para testes)
  Future<void> simulatePremiumPurchase() async {
    await _savePremiumStatus(true);
    _disposeBannerAd();
  }

  // Remover premium (para testes)
  Future<void> removePremium() async {
    await _savePremiumStatus(false);
    await _initializeAds();
  }
}