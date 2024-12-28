//
//  DetailLawyerViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 22/12/24.
//

import UIKit
import Kingfisher

class DetailLawyerViewController: UIViewController {
    
    var lawyer: Lawyer? // Abogado seleccionado
    
    // User principal info
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ratingLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let userDescriptionLabel = UILabel()

    // Atractive client info
    private let userLocation = UILabel()
    private let projectsWorkedLabel = UILabel()
    private let numberOfHiringsLabel = UILabel()
    private let profileViewsLabel = UILabel()
    private let skillsLabel = UILabel()
    private let hourlyRateLabel = UILabel()
    
    // Contacts
    private let contactButton = UIButton(type: .system)
    private let contractButton = UIButton(type: .system)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
            // Imagen de perfil
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        if let imageUrlString = lawyer?.imageURL, let imageUrl = URL(string: imageUrlString) {
            profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "person.circle"))
        } else {
            profileImageView.image = UIImage(systemName: "person.circle")
        }
        
            // Nombre del abogado
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.text = lawyer?.name
        nameLabel.textAlignment = .center
        
            // Calificación
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 16)
        ratingLabel.text = "⭐️ \(lawyer?.rating ?? 0) (120 reviews)"
        ratingLabel.textAlignment = .center
        ratingLabel.textColor = .gray
        
            // Descripción
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionLabel.text = lawyer?.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        
            // User Descripción
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        userDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        userDescriptionLabel.text = lawyer?.userDescription
        userDescriptionLabel.numberOfLines = 0
        userDescriptionLabel.textAlignment = .left
        
                    // Información general (ubicación, nivel, idiomas)
        let locationStack = createInfoStack(iconName: "mappin.and.ellipse", text: "Ubicación: Ecatepec, Morelos")
        let levelStack = createInfoStack(iconName: "folder", text: "Proyectos: \(lawyer?.projectsWorkedOn ?? 0)")
        let numberHiringsStack = createInfoStack(iconName: "person.crop.circle.badge.plus", text: "Contrataciones: \(lawyer?.numberOfHirings ?? 0)")
        let languagesStack = createInfoStack(iconName: "globe", text: "Idiomas: Español, Ingles")
        let profileViewsStack = createInfoStack(iconName: "eyes.inverse", text: "Vistas en el perfil: \(lawyer?.profileViews ?? 0)")
        let hourlyRateStack = createInfoStack(iconName: "hourglass.circle", text: "Cobro por hora: $ \(lawyer?.hourlyRate ?? 0)")
//        let skillsStack = createInfoStack(iconName: "list.bullet", text: "Habilidades: \(skillsLabel.text ?? "")")

        
        if let lawyerSkills = lawyer?.skills {
            // Generar una cadena con viñetas
            let bulletPoints = lawyerSkills.map { "• \($0)" }.joined(separator: "\n")
            skillsLabel.text = bulletPoints
        }
        skillsLabel.translatesAutoresizingMaskIntoConstraints = false
        skillsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        skillsLabel.numberOfLines = 0
        skillsLabel.textAlignment = .left // Alinear a la izquierda para parecer una lista
        skillsLabel.textColor = .systemBlue

        // Crear fila para el título de habilidades
        let skillsTitleStack = createInfoStack(iconName: "list.bullet", text: "Habilidades:")
        

        let infoStack = UIStackView(arrangedSubviews: [
            locationStack,
            levelStack,
            numberHiringsStack,
            languagesStack,
            profileViewsStack,
            hourlyRateStack,
            skillsTitleStack,
            skillsLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 10
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        
//        skillsLabel.translatesAutoresizingMaskIntoConstraints = false
//        skillsLabel.font = UIFont.systemFont(ofSize: 14)
//        skillsLabel.numberOfLines = 0
//        skillsLabel.textAlignment = .left // Alinear a la izquierda para parecer una lista

        

        
            // Botón de contacto
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        contactButton.setTitle("Contacto", for: .normal)
        contactButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        contactButton.backgroundColor = UIColor.systemGreen
        contactButton.setTitleColor(.white, for: .normal)
        contactButton.layer.cornerRadius = 10
                    
            // Botón de contacto
        contractButton.translatesAutoresizingMaskIntoConstraints = false
        contractButton.setTitle("Contratar", for: .normal)
        contractButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        contractButton.backgroundColor = UIColor.blue
        contractButton.setTitleColor(.white, for: .normal)
        contractButton.layer.cornerRadius = 10
        
            // Agregar subviews
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(ratingLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(userDescriptionLabel)
        
        
        view.addSubview(infoStack)
        
//        view.addSubview(skillsLabel)
        
        view.addSubview(contactButton)
        view.addSubview(contractButton)
        
        
        // targets
        contactButton.addTarget(self, action: #selector(contactAction), for: .touchUpInside)
        contractButton.addTarget(self, action: #selector(contractAction), for: .touchUpInside)
        
            // Configurar restricciones
        NSLayoutConstraint.activate([
            // Imagen de perfil
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Nombre
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Calificación
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Descripción
            descriptionLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            // User Descripción
            userDescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        
            // Información general
            infoStack.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 20),
            infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

//            // User Descripción
//            skillsLabel.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 10),
//            skillsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            skillsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Botón de contacto
            contactButton.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 20),
            contactButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contactButton.widthAnchor.constraint(equalToConstant: 150),
            contactButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Botón de contratar
            contractButton.topAnchor.constraint(equalTo: contactButton.bottomAnchor, constant: 20),
            contractButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contractButton.widthAnchor.constraint(equalToConstant: 150),
            contractButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // Función para crear una fila con icono y texto
    private func createInfoStack(iconName: String, text: String) -> UIStackView {
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = .gray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray

        let stack = UIStackView(arrangedSubviews: [iconImageView, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }
    @objc private func contactAction(){
        self.performSegue(withIdentifier: "contactSegue", sender: nil)
    }
    
    @objc private func contractAction(){
        print("Contract Press")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "contactSegue":
            let destination =  segue.destination as! ContactViewController
            destination.lawyer = lawyer
        case "contractSegue":
            let destination =  segue.destination as! ContractViewController
            destination.lawyer = lawyer
        default:
            print("Segue not found")
            
        }
    }
    
}
