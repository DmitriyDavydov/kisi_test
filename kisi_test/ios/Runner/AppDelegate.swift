import UIKit
import Flutter
import SecureAccess

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

   let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

          let kisiChannel = FlutterMethodChannel(name: "kisi.test/kisi_channel", binaryMessenger: controller.binaryMessenger)

      kisiChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        // This method is invoked on the UI thread.
        guard call.method == "kisiTapToAccess" else {
          result(FlutterMethodNotImplemented)
          return
        }
          self?.kisiTapToAccess(result: result)
      })
      
       
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func kisiTapToAccess(result: FlutterResult) {
        let kisiDataProvider = TapToAccessKisiDataProvider()
        
        if #available(iOS 13.0, *) {
            TapToAccessManager.shared.delegate = kisiDataProvider
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 13.0, *) {
            TapToAccessManager.shared.start()
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 13.0, *) {
            //result(TapToAccessManager.shared.delegate?.tapToAccessClientID())
            TapToAccessManager.shared.delegate?.tapToAccessClientID()
            result(true)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}

