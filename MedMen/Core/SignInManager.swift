//
//  SignInManager.swift
//  MedMen
//
//  Created by Jan Zimandl on 09.11.2021.
//

import Foundation
import AppAuth
import AuthenticationServices

struct SignInConfiguration {
    let authorizationEndpointUrl: String
    let tokenEndpointUrl: String
    let clientId: String
    let redirectUrlScheme: String
    let responseType: String
    var scopes: [String]

    static func google(clientId: String, redirectUrlScheme: String, scopes: [String]) -> Self {
        return SignInConfiguration(
            authorizationEndpointUrl: "https://accounts.google.com/o/oauth2/auth",
            tokenEndpointUrl: "https://oauth2.googleapis.com/token",
            clientId: clientId,
            redirectUrlScheme: redirectUrlScheme,
            responseType: OIDResponseTypeCode,
            scopes: scopes)
    }
}

class SignInManager {

    enum SingInError: Error {
        case wrongSingInUrlFormat
        case wrongConfiguration
        case singInCanceled
        case noAccessToken
        case signInError(error: Error)
        case unknownError
    }

    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    private var authState: OIDAuthState?

    init() {}

    func signIn(config: SignInConfiguration, in vc: UIViewController, completion: @escaping (_ result: Result<String, SingInError>) -> Void) {

        let redirectUri = config.redirectUrlScheme + ":/medmen.com/oauth"
        guard let redirectURL = URL(string: redirectUri),
              let authorizationEndpoint = URL(string: config.authorizationEndpointUrl),
              let tokenEndpoint = URL(string: config.tokenEndpointUrl) else {
            completion(.failure(.wrongConfiguration))
            return
        }

        let configuration = OIDServiceConfiguration(authorizationEndpoint: authorizationEndpoint, tokenEndpoint: tokenEndpoint)

        let request = OIDAuthorizationRequest(configuration: configuration, clientId: config.clientId, scopes: config.scopes, redirectURL: redirectURL, responseType: config.responseType, additionalParameters: nil)

        self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: vc) { [weak self] authState, error in
            self?.authState = authState
            if let authState = authState {

                authState.performAction { (_, idToken, error) in

                    if let tok = idToken {
                        print("SignInManager: Authorization successful: idToken: \(tok)")
                        completion(.success(tok))
                    } else {
                        print("SignInManager: Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                        let signInError = Self.processError(error)
                        completion(.failure(signInError))
                    }

                }

            } else {
                print("SignInManager: Authorization error: \(error?.localizedDescription ?? "Unknown error")")
                let signInError = Self.processError(error)
                completion(.failure(signInError))
            }
        }
    }

    private static func processError(_ error: Error?) -> SingInError {
        guard let err = error else {
            return .unknownError
        }

        let defaultError: SingInError = .signInError(error: err)

        var nsError = err as NSError
        if let uErr = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
            nsError = uErr
        }

        switch nsError.domain {
        case ASWebAuthenticationSessionError.errorDomain:
            switch nsError.code {
            case ASWebAuthenticationSessionError.Code.canceledLogin.rawValue:
                return .singInCanceled
            default:
                break
            }
        default:
            break
        }

        return defaultError
    }
}

extension SignInConfiguration {
    static func config(from url: URL?) -> SignInConfiguration? {
        guard let url = url, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        var params = [String: String]()
        for item in urlComponents.queryItems ?? [] {
            params[item.name] = item.value ?? ""
        }

        guard
            params["client_id"] != nil,
            params["redirect_uri"] != nil,
            params["response_type"] != nil,
            let scope = params["scope"]
        else {
            return nil
        }

        let scopes = scope.split(separator: " ").map({ String($0) })

        let googleSignInUrl = "https://accounts.google.com"

        if url.absoluteString.contains(googleSignInUrl) {
            print("GOOGLE url: \(url)")
            return Self.google(clientId: MMConstants.GoogleSignIn.clientId, redirectUrlScheme: MMConstants.GoogleSignIn.redirectUrlScheme, scopes: scopes)
        } else {
            return nil
        }
    }
}

// MARK: - DisplayableError

extension SignInManager.SingInError: DisplayableError {
    var title: String? {
        return nil
    }

    var message: String? {
        switch self {
        case .wrongSingInUrlFormat, .wrongConfiguration, .unknownError:
            return "Something went wrong. Please try it again later."
        case .singInCanceled:
            return nil
        case .noAccessToken:
            return "Sign in failed."
        case .signInError(let error):
            return error.localizedDescription
        }
    }
}
