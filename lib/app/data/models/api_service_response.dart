// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:innsouls_flutter/app/common/utils/log_helper.dart';
// import 'package:innsouls_flutter/app/data/errors/api_error.dart';
//
// class ApiResponse<T> {
//   final bool success;
//   final T? data;
//   final ApiError? error;
//
//   bool get hasNetworkError {
//     if (error != null) {
//       if (error!.type == ErrorType.noConnection || error!.type == ErrorType.connectTimeout) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   ApiResponse({
//     required this.success,
//     this.data,
//     this.error,
//   });
//
//   static ApiResponse<T> getResponse<T>(Response response, T Function(Map<String, dynamic>) fromJson) {
//     final statusCode = response.statusCode;
//
//     if (response.statusMessage == 'networkError') {
//       return noNetworkError();
//     } else if (statusCode == HttpStatus.requestTimeout) {
//       return connectionTimeout();
//     }
//
//     try {
//       final data = fromJson(response.data);
//       if (statusCode == HttpStatus.unauthorized) {
//         return unauthorized(data);
//       }
//       return ApiResponse<T>(success: true, data: data);
//     } on FormatException {
//       return unknownError(null);
//     } on TimeoutException {
//       return connectionTimeout();
//     } catch (e, es) {
//       printDebug("Unhandled api error: $e");
//       printDebug("Unhandled api error stack: $es");
//       return unknownError(null);
//     }
//   }
//
//   static ApiResponse<Map<dynamic, dynamic>?> getResponseJson(Response response) {
//     final statusCode = response.statusCode;
//     final String result = response.data.toString();
//
//     if (response.statusMessage == 'networkError') {
//       return noNetworkError();
//     } else if (statusCode == HttpStatus.requestTimeout) {
//       return connectionTimeout();
//     }
//
//     try {
//       final res = jsonDecode(result);
//       if (statusCode == HttpStatus.unauthorized) {
//         return unauthorized(res);
//       }
//
//       if (res is Map) {
//         return ApiResponse<Map<dynamic, dynamic>>(success: true, data: res);
//       }
//     } on FormatException {
//       return unknownError(null);
//     } on TimeoutException {
//       return connectionTimeout();
//     } catch (e, es) {
//       printDebug("Unhandled api error: $e");
//       printDebug("Unhandled api error stack: $es");
//       return unknownError(null);
//     }
//     return ApiResponse<Map<dynamic, dynamic>>(success: false, data: null);
//   }
//
//   static ApiResponse<T> noNetworkError<T>() {
//     return ApiResponse<T>(
//       success: false,
//       error: const ApiError(type: ErrorType.noConnection, error: 'No internet connection.'),
//     );
//   }
//
//   static ApiResponse<T> dioError<T>({String? errorMessage}) {
//     return ApiResponse<T>(
//       success: false,
//       error: ApiError(type: ErrorType.dioError, error: errorMessage ?? 'Dio exception.'),
//     );
//   }
//
//   static ApiResponse<T> serverError<T>() {
//     return ApiResponse<T>(
//       success: false,
//       error: const ApiError(type: ErrorType.response, error: 'Server error occurred.'),
//     );
//   }
//
//   static ApiResponse<T> connectionTimeout<T>() {
//     return ApiResponse<T>(
//       success: false,
//       error: const ApiError(type: ErrorType.connectTimeout, error: 'Connection timeout.'),
//     );
//   }
//
//   static ApiResponse<T> unauthorized<T>(T? data) {
//     return ApiResponse<T>(
//       success: false,
//       data: data,
//       error: const ApiError(type: ErrorType.unauthorize, error: 'Unauthorized request.'),
//     );
//   }
//
//   static ApiResponse<T> unknownError<T>(T? data) {
//     return ApiResponse<T>(
//       success: false,
//       data: data,
//       error: const ApiError(type: ErrorType.unknownError, error: 'Unknown error occurred.'),
//     );
//   }
// }
