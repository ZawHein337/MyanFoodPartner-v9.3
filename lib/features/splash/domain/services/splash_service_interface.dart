abstract class SplashServiceInterface {
  Future<dynamic> getConfigData();
  Future<bool> initSharedData();
  Future<bool> removeSharedData();
  bool showIntro();
  void setIntro(bool intro);
  bool handleInitialTopicSubscription();
}