// import 'package:dio/dio.dart';
// import 'package:innsouls_flutter/app/common/dialogs/app_dialogs.dart';
// import 'package:innsouls_flutter/app/common/utils/loading_dialog.dart';
// import 'package:innsouls_flutter/app/common/utils/log_helper.dart';
// import 'package:innsouls_flutter/app/data/models/api_service_response.dart';
//
// class ApiController {
//   static Future<ApiResponse<T>> handle<T>(Future<ApiResponse<T>> Function() apiCall, {AsyncOptions? asyncOptions}) async {
//     asyncOptions ??= AsyncOptions();
//     try {
//       if (asyncOptions.showLoadingUntilFinish) await Future.delayed(const Duration(milliseconds: 0), LoadingDialog.show);
//       return await apiCall();
//     } on DioException catch (e) {
//       printDebug(' Dio Exaeption ${e.error}');
//       if (asyncOptions.showErrorDialog) {
//         await AppDialogs.show(title: '', message: e.message);
//       }
//       return ApiResponse.dioError(errorMessage: e.message);
//     } catch (e) {
//       printDebug("Api Error : $e");
//       return ApiResponse.noNetworkError();
//     } finally {
//       if (asyncOptions.showLoadingUntilFinish) LoadingDialog.close();
//     }
//   }
// }
//
// class AsyncOptions {
//   final bool showErrorDialog;
//   final bool showLoadingUntilFinish;
//   AsyncOptions({this.showErrorDialog = false, this.showLoadingUntilFinish = false});
// }
