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
    private let pluginVersion: String = "8.1.1"
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

        if #available(iOS 26.2, *) {
            saveWithCredentialDataManager(
                call,
                username: username,
                password: password,
                url: url,
                title: call.getString("title")
            )
            return
        }

        saveWithSharedWebCredential(call, username: username, password: password, url: url)
    }

    @available(iOS 26.2, *)
    private func saveWithCredentialDataManager(
        _ call: CAPPluginCall, username: String, password: String, url: String, title: String?
    ) {
        Task { @MainActor in
            guard let anchor = self.bridge?.viewController?.view.window else {
                call.reject("Failed to save credential", "No window to present the save prompt from")
                return
            }
            do {
                try await ASCredentialDataManager().save(
                    password: ASPasswordCredential(user: username, password: password),
                    for: Self.autoFillScope(for: url),
                    title: title,
                    anchor: anchor
                )
                call.resolve()
            } catch {
                call.reject("Failed to save credential", error.localizedDescription)
            }
        }
    }

    @available(iOS 26.2, *)
    private static func autoFillScope(for url: String) -> ASAutoFillURLScope {
        // `url` is documented as a bare FQDN, but tolerate a full URL rather than
        // handing "https://example.com" to the host initialiser verbatim
        guard let parsed = URL(string: url), parsed.scheme != nil,
              let scope = ASAutoFillURLScope(url: parsed) else {
            return ASAutoFillURLScope(host: url)
        }
        return scope
    }

    @available(iOS, deprecated: 26.2, message: "Superseded by ASCredentialDataManager")
    private func saveWithSharedWebCredential(_ call: CAPPluginCall, username: String, password: String, url: String) {
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
            self.authController = ASAuthorizationController(authorizationRequests: [passwordRequest])
            self.currentReadCall = call
            self.authController?.delegate = self
            self.authController?.presentationContextProvider = self
            self.authController?.performRequests()
        }
    }

    private var currentReadCall: CAPPluginCall?
    private var currentCall: CAPPluginCall?
    private var authController: ASAuthorizationController?

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
        self.authController = nil
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let call = currentReadCall {
            call.reject("Autofill failed", error.localizedDescription)
            currentReadCall = nil
            return
        }
        currentCall?.reject("Autofill failed", error.localizedDescription)
        currentCall = nil
        self.authController = nil
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.bridge?.viewController?.view.window ?? ASPresentationAnchor()
    }

    @objc func getPluginVersion(_ call: CAPPluginCall) {
        call.resolve(["version": self.pluginVersion])
    }
}
