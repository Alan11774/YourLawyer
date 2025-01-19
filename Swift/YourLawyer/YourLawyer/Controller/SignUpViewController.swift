//
//  SignUpViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 18/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    // UI Components
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let firstNameLabel = UILabel()
    let firstNameField = UITextField()
    let lastNameLabel = UILabel()
    let lastNameField = UITextField()
    let emailLabel = UILabel()
    let emailField = UITextField()
    let passwordLabel = UILabel()
    let passwordField = UITextField()
    let chooseTypeLabel = UILabel()
    let typeSegmentedControl = UISegmentedControl(items: ["Busco un Abogado", "Soy Abogado"]) //For UI Switch
    let termsCheckbox = UIButton(type: .system)
    let termsLabel = UILabel()
    let joinButton = UIButton(type: .system)
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
            
    func setupUI() {
        // Title
        titleLabel.text = "YourLawyer"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = "Encuentra el abogado a tu medida!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
        // Labels and TextFields
        configureLabel(firstNameLabel, text: "Nombre")
        configureTextField(firstNameField, placeholder: "Nombre*")
        
        configureLabel(lastNameLabel, text: "Apellido")
        configureTextField(lastNameField, placeholder: "Apellido*")
        
        configureLabel(emailLabel, text: "Email")
        configureTextField(emailField, placeholder: "Correo electronico*")
        
        configureLabel(passwordLabel, text: "Contraseña")
        configureTextField(passwordField, placeholder: "Ingresa tu contraseña*", isSecure: true)
        
        // Choose Type
        chooseTypeLabel.text = "Escoge una opción"
        chooseTypeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        typeSegmentedControl.selectedSegmentIndex = 0
        
        // Terms Checkbox
        termsCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        termsCheckbox.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        termsCheckbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        
        termsLabel.text = "He leido los terminos y condiciones"
        termsLabel.font = UIFont.systemFont(ofSize: 12)
        termsLabel.textColor = .systemGray
        
        // Join Now Buttonunete
        joinButton.setTitle("Unete Ahora", for: .normal)
        joinButton.backgroundColor = .systemBlue
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.layer.cornerRadius = 8
        
        activityIndicator.color = .gray
        activityIndicator.style = .medium
        activityIndicator.center = view.center

        // Add Subviews
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, subtitleLabel,
            firstNameLabel, firstNameField,
            lastNameLabel, lastNameField,
            emailLabel, emailField,
            passwordLabel, passwordField,
            chooseTypeLabel, typeSegmentedControl
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        view.addSubview(termsCheckbox)
        view.addSubview(termsLabel)
        view.addSubview(joinButton)
        view.addSubview(activityIndicator)
        
        joinButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        
        // Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        termsCheckbox.translatesAutoresizingMaskIntoConstraints = false
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            termsCheckbox.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            termsCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            termsCheckbox.widthAnchor.constraint(equalToConstant: 20),
            termsCheckbox.heightAnchor.constraint(equalToConstant: 20),
            
            termsLabel.centerYAnchor.constraint(equalTo: termsCheckbox.centerYAnchor),
            termsLabel.leadingAnchor.constraint(equalTo: termsCheckbox.trailingAnchor, constant: 8),
            termsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            joinButton.topAnchor.constraint(equalTo: termsCheckbox.bottomAnchor, constant: 30),
            joinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            joinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            joinButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
            
    // Helper Functions
    func configureLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func configureTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
    }
    
    @objc func toggleCheckbox() {
        termsCheckbox.isSelected.toggle()
    }
	
	@objc func signUpAction() {
		
		self.activityIndicator.startAnimating()

		
		if !termsCheckbox.isSelected {
			self.activityIndicator.stopAnimating()
			Utils.showMessage("Selecciona los términos y condiciones.")
			return
		}

		
		guard let email = emailField.text, !email.isEmpty,
			  let password = passwordField.text, !password.isEmpty,
			  let firstName = firstNameField.text, !firstName.isEmpty,
			  let lastName = lastNameField.text, !lastName.isEmpty else {
			self.activityIndicator.stopAnimating()
			Utils.showMessage("Por favor, completa todos los campos.")
			return
		}

		
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			self.activityIndicator.stopAnimating()
			
			if let error = error {
				Utils.showMessage("Error al registrar: \(error.localizedDescription)")
				return
			}

			
			let userRole = self.typeSegmentedControl.selectedSegmentIndex == 0 ? "Cliente" : "Abogado"

			// Crear el documento en Firestore
			let db = Firestore.firestore()
			let userProfile: [String: Any] = [
				"name": firstName,
				"lastName": lastName,
				"email": email,
				"hourlyRate": "", // Campo vacío
				"language": [String](), // Lista vacía
				"skills": [String](), // Lista vacía
				"userRole": userRole,
				"userDescription": "" // Campo vacío
			]

			db.collection("users")
				.document(email)
				.collection("profile")
				.document("userInformation")
				.setData(userProfile) { error in
				if let error = error {
					Utils.showMessage("Error al guardar los datos del usuario: \(error.localizedDescription)")
				} else {
					let alertController = UIAlertController(title: "Registro Exitoso", message: "Usuario registrado exitosamente. Por favor, inicia sesión.",preferredStyle: .alert)
					let alertAction = UIAlertAction(title: "Ok", style: .default){_ in
						self.dismiss(animated: true)
					}
					alertController.addAction(alertAction)
					self.present(alertController,animated: true, completion:nil)
					
				}
			}
		}
	}
}
