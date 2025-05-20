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

class LoginScreenViewController: UIViewController {
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.frame.size.width = 1
        textField.frame.size.height = 1
        textField.textContentType = .username
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.frame.size.width = 1
        textField.frame.size.height = 1
        textField.textContentType = .newPassword
        // Fix: from https://stackoverflow.com/questions/76773166/password-autofill-wkwebview-doesnt-present-save-password-alert#comment140186929_76773167
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        usernameTextField.becomeFirstResponder()
    }
}
