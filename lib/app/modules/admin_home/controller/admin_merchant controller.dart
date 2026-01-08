import 'package:get/get.dart';
import '../../../data/models/admin_merchantmodel.dart';

class MerchantRegController extends GetxController {
  var merchantList = <MerchantModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Sample merchants
    merchantList.addAll([
      MerchantModel(
        ownerName: "Alice",
        shopName: "Alice Store",
        email: "alice@example.com",
        phone: "1234567890",
        state: "Kerala",
        district: "Kochi",
        location: "MG Road",
        address: "123, MG Road, Kochi",
      ),
      MerchantModel(
        ownerName: "Bob",
        shopName: "Bob Shop",
        email: "bob@example.com",
        phone: "9876543210",
        state: "Kerala",
        district: "Trivandrum",
        location: "Palayam",
        address: "456, Palayam, Trivandrum",
      ),
    ]);
  }

  // Approve / Reject merchant
  void updateMerchantStatus(int index, String status) {
    merchantList[index].status = status;
    merchantList.refresh();
  }
}
