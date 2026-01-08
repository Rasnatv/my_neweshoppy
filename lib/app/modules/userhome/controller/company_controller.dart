import 'package:get/get.dart';

import '../../../data/models/companymodel.dart';


class CompanyController extends GetxController {
  late Company company;

  void setCompany(Company data) {
    company = data;
  }
}
