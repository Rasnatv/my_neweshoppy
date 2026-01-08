// import 'package:dio/dio.dart';
// import 'package:innsouls_flutter/app/common/constants/api_constants.dart';
// import 'package:innsouls_flutter/app/common/utils/log_helper.dart';
// import 'package:innsouls_flutter/app/core/controllers/auth_controller.dart';
//
// int a = 1;
// mixin ApiServiceMixin on DioMixin {
//   bool _authenticate = true;
//
//   @override
//   BaseOptions get options => BaseOptions(baseUrl: ApiConstants.baseUrl);
//   @override
//   HttpClientAdapter get httpClientAdapter => HttpClientAdapter();
//
//   void _setInterceptor() {
//     super.interceptors.clear();
//     super.interceptors.add(_authenticate ? AppInterceptor.withAuthentication(this) : AppInterceptor.withoutAuthentication(this));
//   }
//
//   @override
//   Future<Response<T>> get<T>(String path,
//       {Map<String, dynamic>? queryParameters,
//       Object? data,
//       Options? options,
//       CancelToken? cancelToken,
//       ProgressCallback? onReceiveProgress,
//       bool authorize = true}) async {
//     _authenticate = authorize;
//     _setInterceptor();
//     return await super
//         .get(path, queryParameters: queryParameters, data: data, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);
//   }
//
//   @override
//   Future<Response<T>> post<T>(String path,
//       {Object? data,
//       Map<String, dynamic>? queryParameters,
//       Options? options,
//       CancelToken? cancelToken,
//       ProgressCallback? onSendProgress,
//       ProgressCallback? onReceiveProgress,
//       bool authorize = true}) async {
//     _authenticate = authorize;
//     _setInterceptor();
//
//     return await super.post(path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress);
//   }
//
//   @override
//   Future<Response<T>> put<T>(String path,
//       {Object? data,
//       Map<String, dynamic>? queryParameters,
//       Options? options,
//       CancelToken? cancelToken,
//       ProgressCallback? onSendProgress,
//       ProgressCallback? onReceiveProgress,
//       bool authorize = true}) async {
//     _authenticate = authorize;
//     _setInterceptor();
//     return super.put(path,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress);
//   }
//
//   @override
//   Future<Response<T>> fetch<T>(RequestOptions requestOptions) {
//     _setInterceptor();
//
//     return super.fetch(requestOptions);
//   }
//
//   @override
//   Future<Response> download(String urlPath, savePath,
//       {ProgressCallback? onReceiveProgress,
//       Map<String, dynamic>? queryParameters,
//       CancelToken? cancelToken,
//       bool deleteOnError = true,
//       String lengthHeader = Headers.contentLengthHeader,
//       Object? data,
//       Options? options,
//       bool authorize = false}) {
//     return super.download(urlPath, savePath,
//         onReceiveProgress: onReceiveProgress,
//         queryParameters: queryParameters,
//         cancelToken: cancelToken,
//         deleteOnError: deleteOnError,
//         lengthHeader: lengthHeader,
//         data: data,
//         options: options);
//   }
// }
//
// class AppInterceptor implements Interceptor {
//   late bool _authenticate;
//   final ApiServiceMixin _apiServiceMixin;
//   AppInterceptor.withAuthentication(this._apiServiceMixin) {
//     _authenticate = true;
//   }
//   AppInterceptor.withoutAuthentication(this._apiServiceMixin) {
//     _authenticate = false;
//   }
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     if (_authenticate) {
//       final authToken = AuthController.to.getUserToken;
//       printDebug('path:  ${options.path}\n token : $authToken');
//       options.headers.addAll({"Authorization": "Bearer $authToken"});
//     }
//     handler.next(options);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401) {
//       if (err.requestOptions.path != ApiConstants.refreshToken) {
//         final token = await AuthController.to.requestRefreshToken();
//         final options = err.requestOptions;
//         if (token != null) {
//           options.headers.clear();
//           options.headers["Authorization"] = "Bearer $token";
//           try {
//             final response = await _apiServiceMixin.fetch(options);
//             printDebug(response.data);
//             handler.resolve(response);
//           } on DioException catch (e) {
//             return handler.next(DioException(requestOptions: options, message: e.message));
//           } catch (e) {
//             return handler.next(DioException(requestOptions: options, message: 'Failed to '));
//           }
//         } else {
//           AuthController.to.logout();
//           return handler.next(DioException(requestOptions: options, message: 'Token refresh failed.'));
//         }
//       } else {
//         AuthController.to.logout();
//         return handler.next(DioException(requestOptions: err.requestOptions, message: 'Login expired'));
//       }
//     }
//     return handler.next(DioException(requestOptions: err.requestOptions, message: err.response?.data?['message']));
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     final responseData = Response(
//         requestOptions: response.requestOptions,
//         statusCode: response.statusCode,
//         isRedirect: response.isRedirect,
//         statusMessage: response.data['message'],
//         data: response.data['data'] ?? response.data,
//         redirects: response.redirects,
//         headers: response.headers,
//         extra: response.extra);
//     printDebug(responseData.data);
//     return handler.resolve(responseData);
//   }
// }
//
