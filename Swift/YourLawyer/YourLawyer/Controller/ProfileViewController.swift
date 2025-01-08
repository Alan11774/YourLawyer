//
//  ProfileViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 22/12/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth



class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    // MARK: - UI Components
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.image = UIImage(systemName: "person.circle") // Icono por defecto
        return imageView
    }()
    
//    var profile : Profile?
    private let db = Firestore.firestore()
    let email = Auth.auth().currentUser?.email ?? ""
    let userRole = "Cliente"
    
    private let skills = ["Derecho Penal", "Derecho Administrativo", "Derecho Civil", "Derecho Comercial", "Derecho Laboral", "Derecho Constitucional", "Derecho de la Familia", "Derecho de la Justicia", "Derecho de la Constitución", "Derecho de la Constitución"]
    private let languages = ["Español", "Inglés", "Francés", "Portugués", "Alemán", "Italiano", "Japonés", "China", "Coreano", "Indonesia", "Filipino", "Arabés", "Ruso", "Turco", "Polaco", "Chino", "Japonés", "Coreano", "Indonesia", "Filipino", "Arabés", "Ruso", "Turco", "Polaco"]
    
    
    private var addImageButton: UIButton!
    private var nameTextField: UITextField!
    private var lastNameTextField: UITextField!
    private var descriptionTextView: UITextView!
    private var skillsDropdown: UIButton!
    private var selectedSkills: [String] = []
    private var languageDropdown: UIButton!
    private var selectedLanguages: [String] = []
    private var hourlyRateTextField: UITextField!
    private var saveButton: UIButton!
    


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupUIElements()
        fetchUserProfile()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }
    
    
    ///********************************************************************************************
    /// setupConstraints (I hate this) is used for the layout organization.
    ///********************************************************************************************
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            
//            profileImageView.heightAnchor.constraint(equalToConstant: 10),
//            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
            
        ])
    }
    
    
    ///********************************************************************************************
    /// Add elements for the Stack View, and defined values of the elements used in view
    ///********************************************************************************************
    
    private func setupUIElements() {
        stackView.addArrangedSubview(createTitleLabel(text: "Configuración de Perfil"))
        
        stackView.addArrangedSubview(profileImageView)
        profileImageView.layer.cornerRadius = 60
        
        addImageButton = createButton(title: "Añadir Imagen", action: #selector(addImageTapped))
        stackView.addArrangedSubview(addImageButton)
        
        nameTextField = createTextField(placeholder: "Nombre")
        lastNameTextField = createTextField(placeholder: "Apellido")
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(lastNameTextField)
        
        descriptionTextView = createRichTextEditor(placeholder: "Escribe tu descripción...")
        stackView.addArrangedSubview(descriptionTextView)
        skillsDropdown = UIHelpers.createDropdownFieldWithAlert(options: skills, placeholder: "Selecciona tus habilidades")

        languageDropdown = UIHelpers.createDropdownFieldWithAlert(options: languages, placeholder: "Lengua")
        stackView.addArrangedSubview(skillsDropdown)
        stackView.addArrangedSubview(languageDropdown)
        
        hourlyRateTextField = createTextFieldHourly(placeholder: "Ingresa tu precio por hora")
        stackView.addArrangedSubview(hourlyRateTextField)
        
        saveButton = createButton(title: "Guardar", action: #selector(saveProfileToFirebase))
        stackView.addArrangedSubview(saveButton)
    }
    ///********************************************************************************************
    /// Fech Users for previous configgurations
    ///********************************************************************************************
    private func fetchUserProfile(){
        fetchProfileFromFirebase(email: email) { [self] profile in
            if let profile = profile {
                nameTextField.text = profile.name
                nameTextField.textColor = .black
                lastNameTextField.text = profile.lastName
                lastNameTextField.textColor = .black
                descriptionTextView.text = profile.userDescription
                descriptionTextView.textColor = .black
                skillsDropdown.setTitle(profile.skills.joined(separator: ", "), for: .normal)
                languageDropdown.setTitle(profile.language.joined(separator: ", "), for: .normal)
                hourlyRateTextField.text = profile.hourlyRate
                hourlyRateTextField.textColor = .black
                
            } else {
                print("No se pudo obtener el perfil.")
            }
        }
    }
    
    private func fetchProfileFromFirebase(email: String, completion: @escaping (Profile?) -> Void) {
        
        // Referencia al documento dentro de la colección
//        db.collection("profiles").document("cliente").collection(email).getDocuments { snapshot, error in
        db.collection("users").document(email).collection("profile").getDocuments { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error al obtener el perfil: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let documents = snapshot?.documents, let data = documents.first?.data() else {
                    print("No se encontró el perfil para el usuario con email: \(email)")
                    completion(nil)
                    return
                }
                
                do {
                    // Convertir los datos obtenidos a JSON
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    
                    // Decodificar el JSON en el modelo `Profile`
                    let profile = try JSONDecoder().decode(Profile.self, from: jsonData)
                    
                    // Retornar el perfil decodificado
                    completion(profile)
                } catch {
                    print("Error al decodificar el perfil: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
        ///********************************************************************************************
        /// Post Users  configuration
        ///********************************************************************************************
    
    @objc private func saveProfileToFirebase() {
        selectedSkills.append(skillsDropdown.title(for: .normal) ?? "")
        selectedLanguages.append(languageDropdown.title(for: .normal) ?? "")

        
        let profile = Profile(
            email: email,
            name: nameTextField.text ?? "",
            lastName: lastNameTextField.text ?? "",
            userRole: userRole,
            imageURL: nil,
            userDescription: descriptionTextView.text ?? "",
            skills: selectedSkills,
            language: selectedLanguages,
            hourlyRate: hourlyRateTextField.text ?? "" // Explicit type annotation
        )

        // Enviar los datos a Firebase
        saveToFirebase(profile: profile)
    }

    private func saveToFirebase(profile: Profile) {
        do {
            // Convertir el modelo `Profile` a un diccionario
            let profileData = try JSONEncoder().encode(profile)
            if let json = try JSONSerialization.jsonObject(with: profileData, options: []) as? [String: Any] {
                // Obtén una referencia al documento basado en el email
                let documentRef = db.collection("users").document(email).collection("profile").document("userInformation")
                
                // Usa `setData` con `merge: true` para actualizar o crear el documento
                documentRef.setData(json, merge: true) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            Utils.showMessage("Error al guardar el perfil en Firebase: \(error.localizedDescription)")
                        } else {
                            Utils.showMessage("Perfil guardado/actualizado exitosamente en Firebase.")
                        }
                    }
                }
            }
        } catch {
            Utils.showMessage("Error al codificar el perfil: \(error.localizedDescription)")
        }
    }
    
        ///********************************************************************************************
        /// Interface methods
        ///********************************************************************************************
           private func createTitleLabel(text: String) -> UILabel {
               let label = UILabel()
               label.text = text
               label.font = UIFont.boldSystemFont(ofSize: 24)
               label.textAlignment = .center
               return label
           }
           
           private func createButton(title: String, action: Selector) -> UIButton {
               let button = UIButton(type: .system)
               button.setTitle(title, for: .normal)
               button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
               button.backgroundColor = UIColor.systemBlue
               button.setTitleColor(.white, for: .normal)
               button.layer.cornerRadius = 8
               button.heightAnchor.constraint(equalToConstant: 40).isActive = true
               button.addTarget(self, action: action, for: .touchUpInside)
               return button
           }
           
           private func createTextField(placeholder: String) -> UITextField {
               let textField = UITextField()
               textField.placeholder = placeholder
               textField.borderStyle = .roundedRect
               return textField
           }
           
           private func createTextFieldHourly(placeholder: String) -> UITextField {
               let textField = UITextField()
               textField.placeholder = "$ \(placeholder)"
               textField.borderStyle = .roundedRect
               return textField
           }
           
           private func createRichTextEditor(placeholder: String) -> UITextView {
               let textView = UITextView()
               textView.layer.borderWidth = 1
               textView.layer.borderColor = UIColor.lightGray.cgColor
               textView.layer.cornerRadius = 8
               textView.font = UIFont.systemFont(ofSize: 16)
               textView.text = placeholder
               textView.textColor = .lightGray
               textView.isScrollEnabled = false
               textView.translatesAutoresizingMaskIntoConstraints = false
               textView.delegate = self
               
               // Altura para 5 líneas
               let lineHeight = textView.font?.lineHeight ?? 20
               textView.heightAnchor.constraint(equalToConstant: lineHeight * 5).isActive = true
               
               return textView
           }
    
        ///********************************************************************************************
        /// Delegates for Text View
        ///********************************************************************************************
        // MARK: - UITextViewDelegate
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .lightGray {
                textView.text = ""
                textView.textColor = .black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Escribe tu descripción..."
                textView.textColor = .lightGray
            }
        }
        ///********************************************************************************************
        /// Upload image in screen
        ///********************************************************************************************
    // MARK: - Actions
    @objc private func addImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

}

