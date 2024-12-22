//
//  AllLawyersTableViewCell.swift
//  YourLawyer
//
//  Created by Alan Ulises on 21/12/24.
//

import UIKit

class AllLawyersTableViewCell: UITableViewCell {

        // Componentes de la celda
        let profileImageView = UIImageView()
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            // Configuración de la imagen
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.clipsToBounds = true
            profileImageView.layer.cornerRadius = 8
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(profileImageView)
            
            // Configuración del título
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.numberOfLines = 1
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(titleLabel)
            
            // Configuración del subtítulo
            subtitleLabel.font = UIFont.systemFont(ofSize: 14)
            subtitleLabel.textColor = .gray
            subtitleLabel.numberOfLines = 2
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subtitleLabel)
            
            // Constraints para los elementos
            NSLayoutConstraint.activate([
                // Imagen
                profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                profileImageView.widthAnchor.constraint(equalToConstant: 60),
                profileImageView.heightAnchor.constraint(equalToConstant: 60),
                
                // Título
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Subtítulo
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
            ])
        }
    
    }
