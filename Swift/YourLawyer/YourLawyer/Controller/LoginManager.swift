//
//  LoginManager.swift
//  Barman
//
//  Created by Alan Ulises on 16/12/24.
//

import Foundation
import GoogleSignIn
import AuthenticationServices

class LoginManager {
    static let shared = LoginManager()

//    func customLogin(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
//        Services().loginService(email, password) { dict in
//            DispatchQueue.main.async {
//                guard let code = dict?["code"] as? Int,
//                      let message = dict?["message"] as? String else {
//                    completion(false, "Error desconocido.")
//                    return
//                }
//                if code == 200 {
//                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
//                    completion(true, nil)
//                } else {
//                    completion(false, message)
//                }
//            }
//        }
//    }

    func googleSignIn(presenting viewController: UIViewController, completion: @escaping (Bool, String?) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                completion(true, nil)
            }
        }
    }

    func appleSignIn(presenting viewController: ASAuthorizationControllerPresentationContextProviding, completion: @escaping (Bool, String?) -> Void) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.presentationContextProvider = viewController
        authController.performRequests()
        completion(true, nil)
    }
    
}
