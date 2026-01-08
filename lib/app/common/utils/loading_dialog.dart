// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// typedef CloseDialog = void Function();
//
// abstract class LoadingDialog {
//   static CloseDialog? _loadingDialog;
//
//   static CloseDialog _showLoadingDialog(bool dismissible) {
//     Get.printInfo(info: 'initialized loading');
//     loadingDialog(dismissible: dismissible);
//     return closeDialog;
//   }
//
//   static void show({bool dismissible = false}) {
//     _loadingDialog = _showLoadingDialog(dismissible);
//     Get.printInfo(info: 'start loading');
//   }
//
//   static void close() {
//     Get.printInfo(info: 'close loading');
//     _loadingDialog?.call();
//   }
//
//   static void loadingDialog({required bool dismissible}) {
//     closeDialog();
//
//     Get.dialog(
//       PopScope(
//         canPop: dismissible,
//         onPopInvokedWithResult: (_, __) async => dismissible,
//         child: const Center(child: CircularProgressIndicator()),
//       ),
//       name: 'loadingDialog',
//       barrierDismissible: dismissible,
//     );
//   }
//
//   static void closeDialog() {
//     if (Get.isDialogOpen == true) {
//       Get.back();
//     }
//   }
// }
