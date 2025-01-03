//
//  CustomLoginViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 18/12/24.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

// *********************************************************************
// Delegado para usar 
// *********************************************************************
protocol CustomLoginDelegate: AnyObject {
    func didCompleteLogin()
    func didPressSignIn()
    func signUpSegue()
}

// *********************************************************************
// Class for Custom Backend (Firebase)
// *********************************************************************


class CustomLoginViewController: UIViewController, UITextFieldDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
// *********************************************************************
// Variable Initialization
// *********************************************************************
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let emailField = UITextField()
    let passwordField = UITextField()
    let rememberMeCheckbox = UIButton()
    let forgetPasswordButton = UIButton()
    let appleIDBtn = ASAuthorizationAppleIDButton()
    let googleBtn = GIDSignInButton()
    let signInButton = UIButton()
    let signUpLabel = UILabel()
    let signUpButton = UIButton()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let networkMonitor = NetworkReachability.shared

    // MARK: - Delegate
    weak var delegate: CustomLoginDelegate?
    
    
    
// *********************************************************************
// Previous Login for user (it saves the session)
// *********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            delegate?.didPressSignIn()
        }else{
            self.view.backgroundColor = .white
            setupViews()
            setupConstraints()
        }
    }
    
// *********************************************************************
// setup views for Sign In Layout
// *********************************************************************
    
    private func setupViews() {
        // Logo
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)

        // Title Label
        titleLabel.text = "Belaw"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Subtitle Label
        subtitleLabel.text = "Ingresa tu correo y contraseña para acceder a tu cuenta"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        // Email Field
        emailField.placeholder = "correo"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailField)

        // Password Field
        passwordField.placeholder = "contraseña"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordField)

        // Remember Me Checkbox
        rememberMeCheckbox.setTitle("Recordar sesión", for: .normal)
        rememberMeCheckbox.setTitleColor(.black, for: .normal)
        rememberMeCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        rememberMeCheckbox.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        rememberMeCheckbox.translatesAutoresizingMaskIntoConstraints = false
        rememberMeCheckbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        view.addSubview(rememberMeCheckbox)

        // Forget Password Button
        forgetPasswordButton.setTitle("¿Olvido su contraseña?", for: .normal)
        forgetPasswordButton.setTitleColor(.systemBlue, for: .normal)
        forgetPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordAction), for: .touchUpInside)
        view.addSubview(forgetPasswordButton)
        
        appleIDBtn.center = self.view.center
        appleIDBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(appleIDBtn)
        appleIDBtn.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)

        googleBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(googleBtn)
        googleBtn.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        
        
        // Sign In Button
        signInButton.setTitle("Ingresar", for: .normal)
        signInButton.backgroundColor = UIColor.systemBlue
        signInButton.layer.cornerRadius = 10
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        view.addSubview(signInButton)

        // Sign Up Label
        signUpLabel.text = "¿No tienes una cuenta?"
        signUpLabel.font = UIFont.systemFont(ofSize: 14)
        signUpLabel.textColor = .gray
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpLabel)

        // Sign Up Button
        signUpButton.setTitle("Registrarse", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        activityIndicator.color = .gray
        activityIndicator.style = .medium
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    
// *********************************************************************
// Constraints for Sign In
// *********************************************************************

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),

            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            // Email Field
            emailField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 40),

            // Password Field
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 40),

            // Remember Me Checkbox
            rememberMeCheckbox.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 15),
            rememberMeCheckbox.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),

            // Forget Password
            forgetPasswordButton.centerYAnchor.constraint(equalTo: rememberMeCheckbox.centerYAnchor),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            
            // Apple Button
            appleIDBtn.topAnchor.constraint(equalTo: rememberMeCheckbox.bottomAnchor, constant: 20),
            appleIDBtn.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            appleIDBtn.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            appleIDBtn.heightAnchor.constraint(equalToConstant: 50),
            
            // Google Button
            googleBtn.topAnchor.constraint(equalTo: appleIDBtn.bottomAnchor, constant: 20),
            googleBtn.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            googleBtn.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            googleBtn.heightAnchor.constraint(equalToConstant: 50),

            // Sign In Button
            signInButton.topAnchor.constraint(equalTo: googleBtn.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 50),

            // Sign Up Label
            signUpLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),

            // Sign Up Button
            signUpButton.leadingAnchor.constraint(equalTo: signUpLabel.trailingAnchor, constant: 5),
            signUpButton.centerYAnchor.constraint(equalTo: signUpLabel.centerYAnchor)
        ])
    }
    
    
// *********************************************************************
// Toggle Action response
// *********************************************************************
    @objc private func toggleCheckbox() {
        rememberMeCheckbox.isSelected.toggle()
    }

    
// *********************************************************************
// Login Action
// *********************************************************************
    
    @objc func loginAction() {
        activityIndicator.startAnimating()
        self.view.endEditing(true)

                guard let email = emailField.text, !email.isEmpty,
                      let password = passwordField.text, !password.isEmpty else {
                    Utils.showMessage("Por favor, completa todos los campos.")
                    return
                }
                
        LoginManager.shared.loginWithEmail(email: email, password: password) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let user):
                            print("Usuario autenticado: \(user.email ?? "Sin email")")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            self.activityIndicator.stopAnimating()
                            self.delegate?.didCompleteLogin()
                        case .failure(let error):
                            self.activityIndicator.stopAnimating()
                            Utils.showMessage("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
    
// *********************************************************************
// Hanlde Google login to Login Interface
// *********************************************************************
    
    @objc func handleGoogleLogin() {
        LoginManager.shared.loginWithGoogle(presenting: self){ result in
            DispatchQueue.main.async {
                switch result {
                 case .success(let user):
                     print("Usuario autenticado: \(user.email ?? "Sin email")")
                     UserDefaults.standard.set(true, forKey: "isLoggedIn")
                     self.delegate?.didCompleteLogin()
                 case .failure(let error):
                    Utils.showMessage("Error: \(error.localizedDescription)")
                 }
            }
            
        }
    }
        
    
// *********************************************************************
// Handle Apple login to Login Interface
// *********************************************************************
    @objc private func handleAppleLogin() {
        
        LoginManager.shared.appleSignIn(presenting: self) { success, error in
            if success {
                UserDefaults.standard.set(self.rememberMeCheckbox.isSelected, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                self.delegate?.didCompleteLogin()
            } else {
                Utils.showMessage("Apple Login Error: \(error ?? "Unknown")")
            }
        }
    }
//*********************************************************************
// Sign Up , register user
// *********************************************************************
    @objc private func forgetPasswordAction() {
        print("Forget Password")
    }
//*********************************************************************
// Sign Up , register user
// *********************************************************************
    @objc private func signUpAction() {
        self.delegate?.signUpSegue()
    }
    
    
    func showNoConnectionAlert() {
        Utils.showMessage("No tienes conexión a internet. Verifica tu red.")
     }
    
// *********************************************************************
// Estado del Login
// *********************************************************************
    func detectaEstado() { // revisa si el usuario ya inició sesión
        // TODO: si es customLogin, hay que revisar en UserDefaults
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            print("Sesión iniciada con Custom Login")
            self.delegate?.didCompleteLogin()
            return
        }
        
        // si está loggeado con Google
        GIDSignIn.sharedInstance.restorePreviousSignIn { usuario, error in
            guard let perfil = usuario else { return }
            print("usuario: \(perfil.profile?.name ?? ""), correo: \(perfil.profile?.email ?? "")")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            self.delegate?.didCompleteLogin()
        }
    }
    
}
