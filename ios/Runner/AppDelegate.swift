import Flutter
import UIKit
import GoogleMaps  // Add this only if using google_maps_flutter

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Add this only if using google_maps_flutter
    GMSServices.provideAPIKey("AIzaSyAnKXxYTw3kCdtNo_r6MN4A6rFLl_oWjbs")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}