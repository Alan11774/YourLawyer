//
//  LoginManager.swift
//  Barman
//
//  Created by Alan Ulises on 16/12/24.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
import FirebaseCore


class LoginManager {
    static let shared = LoginManager()
    
    
    func loginWithEmail(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let firebaseUser = authResult?.user {
                completion(.success(firebaseUser))
            } else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Usuario no encontrado"])))
            }
        }
    }
    
    
    func loginWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleLogin", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error en las credenciales de Google"])))
                return
            }
            
            // Autenticación con Firebase
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let firebaseUser = authResult?.user {
                    completion(.success(firebaseUser))
                } else {
                    completion(.failure(NSError(domain: "FirebaseAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Usuario no encontrado"])))
                }
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
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
            UserDefaults.standard.synchronize()
            GIDSignIn.sharedInstance.signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
}

