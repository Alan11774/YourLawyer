//
//  PostCaseViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 13/01/25.
//

import UIKit

class PostCaseViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    private var tag1 = UIHelpers.createDropdownFieldWithAlert(options: requirements, placeholder: "Selecciona tus primer tag")
    private var tag2 = UIHelpers.createDropdownFieldWithAlert(options: requirements, placeholder: "Selecciona tu segundo tag")
    private var tag3 = UIHelpers.createDropdownFieldWithAlert(options: requirements, placeholder: "Selecciona tu tercer tag")
    
    private var publishButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
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

            // Content Stack
            stackView.axis = .vertical
            stackView.spacing = 16
            stackView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(stackView)

            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
        
            profileImageView.contentMode = .scaleAspectFill // Cambiado para mejor ajuste
            profileImageView.clipsToBounds = true
            profileImageView.layer.cornerRadius = 50 // Esto asegura que sea circular
            profileImageView.layer.borderWidth = 2.0 // Opcional: Agregar borde
            profileImageView.layer.borderColor = UIColor.lightGray.cgColor // Opcional: Color del borde
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.image = UIImage(systemName: "photo")
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(profileImageView)

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
            
            stackView.addArrangedSubview(categoryPicker)

            // Description TextField
            
//            descriptionTextField.placeholder = "Describe tu caso"
//            descriptionTextField.borderStyle = .roundedRect
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
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        

        locationTextField.placeholder = "Añade tu ubicación"
        stackView.addArrangedSubview(createHorizontalRow(imageName: "location", spinnerID: locationTextField))
        
        budgetTextField.placeholder = "Ingresa tu presupuesto 0-999999 MXN"
        stackView.addArrangedSubview(createHorizontalRow(imageName: "dollarsign", spinnerID: budgetTextField))
        
        postedLabel.text = "Posteado por : juan mecanico el dia 19/02/2024"
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
        }
    
    
        // MARK: - Actions
        @objc private func addImageAction() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        
        
        // MARK: - UIImagePickerControllerDelegate
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
    
    private func createHorizontalRow(imageName: String, spinnerID: UIView) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 20
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Crear ImageView
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let spinnerButton = spinnerID
//        spinnerButton.setTitleColor(.black, for: .normal)
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



