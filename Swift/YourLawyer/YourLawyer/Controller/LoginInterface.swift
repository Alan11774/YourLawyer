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
import FirebaseAuth

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
	
	
	func initializeProfile(completion: @escaping () -> Void) {
		if let user = Auth.auth().currentUser, let email = user.email {
			UserProfileService.shared.fetchUserProfile(email: email) { result in
				switch result {
				case .success(let profile):
					ProfileManager.shared.signedInProfile = profile
					print("Perfil obtenido: \(profile)")
				case .failure(let error):
					print("Error al obtener el perfil: \(error.localizedDescription)")
				}
				completion() // Llamamos al completion al final de la operación
			}
		} else {
			print("No hay un usuario autenticado.")
			completion() // Llamamos al completion incluso si no hay usuario
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Verificar conexión a internet
		if !networkMonitor.isConnected {
			showNoConnectionAlert()
		} else {
			initializeProfile {
				self.detectaEstado()
			}
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
		print("User Role: \(ProfileManager.shared.signedInProfile?.userRole ?? "No Initialized")")
		self.performSegue(withIdentifier: "loginOK", sender: nil)
	}
	func didCompleteLogin() {
		
		// TODO Encontrar forma de englobar esta accion sin tanta autenticacion 
		initializeProfile {
			print("User Role: \(ProfileManager.shared.signedInProfile?.userRole ?? "No Initialized")")
			Utils.showMessage("Login Successful! Navigate to next screen.")
			self.performSegue(withIdentifier: "loginOK", sender: nil)
		}
		
	}
	func signUpSegue(){
		performSegue(withIdentifier: "signUpSegue", sender: nil)
	}
}
