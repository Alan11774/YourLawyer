    //
    //  LoginInterface.swift
    //  Barman
    //
    //  Created by Ángel González on 07/12/24.
    //

    import Foundation
    import UIKit
    import AuthenticationServices
    import GoogleSignIn
    import Firebase

    class LoginInterface: UIViewController, CustomLoginDelegate, ASAuthorizationControllerPresentationContextProviding {
        
        // MARK: - Network Reachability Instance
        let networkMonitor = NetworkReachability.shared
        
        func detectaEstado() { // revisa si el usuario ya inició sesión
            // TODO: si es customLogin, hay que revisar en UserDefaults
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            if isLoggedIn {
                print("Sesión iniciada con Custom Login")
                self.performSegue(withIdentifier: "loginOK", sender: nil)
                return
            }
            
            // si está loggeado con Google
            GIDSignIn.sharedInstance.restorePreviousSignIn { usuario, error in
                guard let perfil = usuario else { return }
                print("Sesion Iniciada con Google usuario: \(perfil.profile?.name ?? ""), correo: \(perfil.profile?.email ?? "")")
                self.performSegue(withIdentifier: "loginOK", sender: nil)
                return

            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // Verificar conexión a internet
            if !networkMonitor.isConnected {
                showNoConnectionAlert()
            } else {
                detectaEstado()
            }
        }
        
        // MARK: - Activity Indicator
        let actInd = UIActivityIndicatorView(style: .large)

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            // Reutilizar CustomLoginViewController
            let loginVC = CustomLoginViewController()
            loginVC.delegate = self // Configura el delegado
            
            // Agregar como vista hija
            self.addChild(loginVC)
            loginVC.view.frame = CGRect(x: 0, y: 45, width: self.view.bounds.width, height: self.view.bounds.height)
            self.view.addSubview(loginVC.view)

        }

        // MARK: - Delegate Implementation
        func didPressSignIn() {
            changeSegue()
        }
        
        // MARK: - Mostrar Alerta Sin Conexión
        func showNoConnectionAlert() {
            let alert = UIAlertController(title: "Sin conexión",
                                          message: "No tienes conexión a internet. Verifica tu red.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
        }
        
        func changeSegue() {
            self.performSegue(withIdentifier: "loginOK", sender: nil)
        }
        func didCompleteLogin() {
            Utils.showMessage("Login Successful! Navigate to next screen.")
            performSegue(withIdentifier: "loginOK", sender: nil)
        }
        func signUpSegue(){
            performSegue(withIdentifier: "signUpSegue", sender: nil)
        }
    }
