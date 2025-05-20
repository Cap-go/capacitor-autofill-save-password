import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(SavePasswordPlugin)
public class SavePasswordPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "SavePasswordPlugin"
    public let jsName = "SavePassword"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "promptDialog", returnType: CAPPluginReturnPromise)
    ]

    @objc func promptDialog(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let loginScreen = LoginScreenViewController()
            loginScreen.usernameTextField.text = call.getString("username") ?? ""
            loginScreen.passwordTextField.text = call.getString("password") ?? ""
            self.bridge?.webView?.addSubview(loginScreen.view)
            loginScreen.view.removeFromSuperview()
            call.resolve()
        }
    }
}
