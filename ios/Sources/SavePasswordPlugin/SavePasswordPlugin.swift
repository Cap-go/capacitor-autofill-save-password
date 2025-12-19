import Foundation
import Capacitor
import Security
import AuthenticationServices

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(SavePasswordPlugin)
public class SavePasswordPlugin: CAPPlugin, CAPBridgedPlugin, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private let pluginVersion: String = "8.0.4"
    public let identifier = "SavePasswordPlugin"

    public let jsName = "SavePassword"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "promptDialog", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "readPassword", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPluginVersion", returnType: CAPPluginReturnPromise)
    ]

    @objc func promptDialog(_ call: CAPPluginCall) {
        guard let username = call.getString("username"),
              let password = call.getString("password") else {
            call.reject("Username and password are required")
            return
        }
        guard let url = call.getString("url") else {
            call.reject("URL is required for iOS shared web credentials")
            return
        }
        let fqdn = url as CFString
        let user = username as CFString
        let pass = password as CFString
        SecAddSharedWebCredential(fqdn, user, pass) { error in
            DispatchQueue.main.async {
                if let error = error {
                    let cfError = error as CFError
                    let description = CFErrorCopyDescription(cfError) as String? ?? "Unknown error"
                    call.reject("Failed to save credential", description)
                } else {
                    call.resolve()
                }
            }
        }
    }

    @objc func readPassword(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let passwordRequest = ASAuthorizationPasswordProvider().createRequest()
            let authController = ASAuthorizationController(authorizationRequests: [passwordRequest])
            self.currentReadCall = call
            authController.delegate = self
            authController.presentationContextProvider = self
            authController.performRequests()
        }
    }

    private var currentReadCall: CAPPluginCall?
    private var currentCall: CAPPluginCall?

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let passwordCredential = authorization.credential as? ASPasswordCredential {
            if let call = currentReadCall {
                call.resolve([
                    "username": passwordCredential.user,
                    "password": passwordCredential.password
                ])
                currentReadCall = nil
                return
            }
            currentCall?.resolve([
                "username": passwordCredential.user,
                "password": passwordCredential.password
            ])
        } else {
            currentReadCall?.resolve()
            currentReadCall = nil
            currentCall?.resolve()
            currentCall = nil
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let call = currentReadCall {
            call.reject("Autofill failed", error.localizedDescription)
            currentReadCall = nil
            return
        }
        currentCall?.reject("Autofill failed", error.localizedDescription)
        currentCall = nil
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.bridge?.viewController?.view.window ?? ASPresentationAnchor()
    }

    @objc func getPluginVersion(_ call: CAPPluginCall) {
        call.resolve(["version": self.pluginVersion])
    }
}
