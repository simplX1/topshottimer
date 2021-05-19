import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Controller extends GetxController{
  //.obs tells the system to observ the variable
  final btnState = true.obs;
  final hasSubscription = false.obs;
  //set global revenueCAT listener
  revenueCatSetListener(String _id) async{
    print("STARTING REVENUECAT:");
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("nCjcXQocpiwSHbFXJKjxASIFgDALbjwA", appUserId: _id);
    Offerings offerings = await Purchases.getOfferings();
    Package package = offerings.current.monthly;
    //an event listener that will auto update depending on the state of the users subscription
    Purchases.addPurchaserInfoUpdateListener((info) async{
      // handle any changes to purchaserInfo
      //TODO button activity here

      print("before active");
      print(info.activeSubscriptions);
      print('after active');
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      if (purchaserInfo.entitlements.all["premium_features"].isActive) {
        print("***************************************************** ACTIVE SUBSCRIBER");
        hasSubscription.value = true;
      } else {
        print("***************************************************** NOT ACTIVE SUBSCRIBER");
        hasSubscription.value = false;
      }
    });
    print("AT THE END OF REVENUECAT");
  }
}
