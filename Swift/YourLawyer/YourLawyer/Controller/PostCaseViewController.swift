//
//  PostCaseViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 13/01/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PostCaseViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	let email = Auth.auth().currentUser?.email ?? ""
	let db = Firestore.firestore()
	var postedDate: String = ""
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var stackView = UIStackView()
    
    private var profileImageView = UIImageView()
    private var uploadImageButton = UIButton(type: .system)
    
    private var titleTextField = UITextField()
    private var categoryPicker = UIHelpers.createDropdownFieldWithAlert(options: categoryLawyers, placeholder: "Selecciona tus categoria")
    private var selectedCategory : [String] = []
    
    private let descriptionTextField: UITextView = UITextView()
//    private var descriptionTextField = UITextField()
    
    private var locationTextField = UITextField()
    private var budgetTextField = UITextField()
    private var postedLabel = UILabel()
    private var urgencyTextField = UITextField()
    
    private var requirement1ImageView = UIImageView()
    private var requirement1 = UIHelpers.createDropdownFieldWithAlert(options: requirements, placeholder: "Selecciona tu primer requerimiento")
    private var requirement2 = UIHelpers.createDropdownFieldWithAlert(options: requirements, placeholder: "Selecciona segundo requerimiento")
	private var tag1 = UIHelpers.createDropdownFieldWithAlert(options: tags, placeholder: "Selecciona tus primer tag")
    private var tag2 = UIHelpers.createDropdownFieldWithAlert(options: tags, placeholder: "Selecciona tu segundo tag")
    private var tag3 = UIHelpers.createDropdownFieldWithAlert(options: tags, placeholder: "Selecciona tu tercer tag")
	
    
    private var publishButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
		let date = Date()
		let dateFormater = DateFormatter()
		dateFormater.dateFormat = "HH:mm:ss"
		postedDate = dateFormater.string(from: date)
        setupUI()

    }
    
    private func setupUI() {
            // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
            // Container for content inside ScrollView
        contentView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
            // Layout for ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
		
		
		profileImageView.contentMode = .scaleAspectFill // Cambiado para mejor ajuste
		profileImageView.clipsToBounds = true
		profileImageView.backgroundColor = .blue
		profileImageView.layer.borderWidth = 2.0 // Opcional: Agregar borde
		profileImageView.layer.borderColor = UIColor.lightGray.cgColor // Opcional: Color del borde
		
		profileImageView.image = UIImage(systemName: "photo")
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(profileImageView)
		NSLayoutConstraint.activate([
		
			profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
			profileImageView.widthAnchor.constraint(equalToConstant: 100),
			profileImageView.heightAnchor.constraint(equalToConstant: 100)
		])
		profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
		profileImageView.layer.masksToBounds = true
		
		
        
            // Content Stack
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        

        NSLayoutConstraint.activate([
                // Constraints para el stackView
                stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16), // Debajo de la imagen de perfil
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16) // Esto asegura que el stackView termine en el bord
        ])
        

        
            // Upload Image Button
        
        uploadImageButton.setTitle("Upload Image", for: .normal)
        uploadImageButton.backgroundColor = .systemBlue
        uploadImageButton.setTitleColor(.white, for: .normal)
        uploadImageButton.layer.cornerRadius = 8
        uploadImageButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stackView.addArrangedSubview(uploadImageButton)
        
            // Title TextField
        
        titleTextField.placeholder = "Título del caso"
        titleTextField.borderStyle = .roundedRect
        stackView.addArrangedSubview(titleTextField)
        
            // Spinner
        
//        stackView.addArrangedSubview(categoryPicker)
		stackView.addArrangedSubview(createHorizontalRow(imageName: "diamond", spinnerID: categoryPicker))
        
            // Description TextField
        
        
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.text = "Describe tu caso...\n\n\n"
        descriptionTextField.font = UIFont.systemFont(ofSize: 16)
        descriptionTextField.textColor = .black
        descriptionTextField.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
        descriptionTextField.layer.cornerRadius = 8
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextField.isScrollEnabled = false // Evita el desplazamiento
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) // Agrega padding interno
        stackView.addArrangedSubview(descriptionTextField)

        locationTextField.placeholder = "Añade tu ubicación"
        stackView.addArrangedSubview(createHorizontalRow(imageName: "location", spinnerID: locationTextField))
        
        budgetTextField.placeholder = "Ingresa tu presupuesto 0-999999 MXN"
        stackView.addArrangedSubview(createHorizontalRow(imageName: "dollarsign", spinnerID: budgetTextField))
        
        postedLabel.text = "Posteado por : \(email) el dia \(postedDate)"
        stackView.addArrangedSubview(createHorizontalRow(imageName: "person.circle", spinnerID: postedLabel))
        
        urgencyTextField.placeholder = "Urgencia: Alta,Media o Baja"
        stackView.addArrangedSubview(createHorizontalRow(imageName: "flame", spinnerID: urgencyTextField))
        
        let titleRequirementsLabel : UILabel = {
            let label = UILabel()
            label.text = "Ingresa los entregables necesarios:"
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return label
        }()
        stackView.addArrangedSubview(titleRequirementsLabel)

        stackView.addArrangedSubview(createHorizontalRow(imageName: "folder", spinnerID: requirement1))
        stackView.addArrangedSubview(createHorizontalRow(imageName: "folder", spinnerID: requirement2))
        
         let titleTagLabel : UILabel = {
            let label = UILabel()
            label.text = "Ingresa las palabras clave que describen tu caso:"
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return label
        }()
        stackView.addArrangedSubview(titleTagLabel)
        stackView.addArrangedSubview(createHorizontalRow(imageName: "smallcircle.filled.circle", spinnerID: tag1))
        stackView.addArrangedSubview(createHorizontalRow(imageName: "smallcircle.filled.circle", spinnerID: tag2))
        stackView.addArrangedSubview(createHorizontalRow(imageName: "smallcircle.filled.circle", spinnerID: tag3))
                
            
            publishButton.setTitle("Publicar", for: .normal)
            publishButton.backgroundColor = .systemBlue
            publishButton.setTitleColor(.white, for: .normal)
            publishButton.layer.cornerRadius = 8
            publishButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
            stackView.addArrangedSubview(publishButton)
        
        // Actions
        uploadImageButton.addTarget(self, action: #selector(addImageAction), for: .touchUpInside)
		publishButton.addTarget(self, action: #selector(verifyFields), for: .touchUpInside)
        }
    
    
    // *********************************************************************************************
    // Image Native selection
    // *********************************************************************************************
    @objc private func addImageAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // Delegados
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {

            profileImageView.image = selectedImage
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            profileImageView.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

		// *********************************************************************************************
		// Logic for strings validation.
		// *********************************************************************************************
	
	@objc private func verifyFields() {
		// Obtener valores de los campos de texto
		let title = titleTextField.text ?? ""
		let description = descriptionTextField.text ?? ""
		let location = locationTextField.text ?? ""
		let budget = budgetTextField.text ?? ""
		let postedBy = "Publicado por: \(email) el día \(postedDate)"
		let urgency = urgencyTextField.text ?? ""
		let category = categoryPicker.titleLabel?.text ?? ""
		let requirement1Val = requirement1.titleLabel?.text ?? ""
		let requirement2Val = requirement2.titleLabel?.text ?? ""
		let tag1Val = tag1.titleLabel?.text ?? ""
		let tag2Val = tag2.titleLabel?.text ?? ""
		let tag3Val = tag3.titleLabel?.text ?? ""

		let variable: [String: Any] = [
			"caseId":"CaseIosExample", // Para un mejor manejo se necesita hacer un backend mas robusto
			"imageURL":"iosImagePlaceholder",
			"title": title,
			"description": description,
			"category": category,
			"postedBy": email,
			"postedDate": postedDate,
			"budget": budget,
			"location": location,
			"status": urgency
//			"details": CaseDetails(
//				tags:[tag1Val,tag2Val,tag3Val],
//				requirements:[requirement1Val,requirement2Val],
//				urgency: urgency
//			),
		]

			// Verificar que todos los campos estén llenos
			let allFieldsFilled = variable.values.allSatisfy {
				if let value = $0 as? String {
					return !value.isEmpty
				}
				return true
			}

			if allFieldsFilled {
				publishInfo(list: variable)
			} else {
				Utils.showMessage("Por favor llena todos los campos")
			}
	}
	
		// *********************************************************************************************
		// Firebase Post information
		// *********************************************************************************************
	
	private func publishInfo(list: [String:Any]){
		let data = db.collection("users")
				.document(email)
				.collection("postedCases")
				.document()

		data.getDocument { document, error in
				if let error = error {
					Utils.showMessage("Error al verificar el perfil: \(error.localizedDescription)")
					return
				}

				if let document = document, document.exists {
					// Si el documento ya existe, actualiza los datos
					data.updateData(list) { error in
						if error != nil {
							Utils.showMessage("Error al postear el caso. Revisa tu conexión a internet e inténtalo más tarde.")
						} else {
							Utils.showMessage("Se ha actualizado tu caso")
							self.navigationController?.popViewController(animated: true)

						}
					}
				} else {
					// Si el documento no existe, crea uno nuevo
					data.setData(list) { error in
						if error != nil {
							Utils.showMessage("Error al postear el caso. Revisa tu conexión a internet o inténtalo más tarde.")
						} else {
							Utils.showMessage("Se ha publicado tu caso.")
						}
					}
				}
			}
	}
    
    // *********************************************************************************************
    // Horizontal Stack for UI
    // *********************************************************************************************
    private func createHorizontalRow(imageName: String, spinnerID: UIView) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 20
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let spinnerButton = spinnerID
        spinnerButton.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
        spinnerButton.layer.cornerRadius = 5
        spinnerButton.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addArrangedSubview(spinnerButton)
        
        NSLayoutConstraint.activate([
            spinnerButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        return horizontalStack
    }
}
