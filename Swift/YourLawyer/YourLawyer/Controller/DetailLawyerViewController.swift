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
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let profileImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        // Asignar datos del abogado a la interfaz
        if let lawyer = lawyer {
            titleLabel.text = lawyer.name
            descriptionLabel.text = lawyer.description
            if let imageUrlString = lawyer.imageURL, let imageUrl = URL(string: imageUrlString) {
                profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "person.circle"))
            } else {
                profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
    }

    private func setupUI() {
        // Configuración de los elementos
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Agregar los elementos a la vista
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        // Configurar las restricciones
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
