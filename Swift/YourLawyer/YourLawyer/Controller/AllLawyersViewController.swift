//
//  AllLawyersViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 19/12/24.
//

import UIKit


class AllLawyersViewController: UIViewController {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "profile_placeholder") // Reemplaza con la imagen de perfil real
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProfileImageView()
    }

    private func setupProfileImageView() {
        view.addSubview(profileImageView)
        
        // Configurar las restricciones para el UIImageView
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Hacer la imagen circular
        profileImageView.layer.cornerRadius = 50 // La mitad del ancho/alto para que sea circular
    }
}
//class AllLawyersViewController: UIViewController {
//
//    @IBAction func ProfileButton(_ sender: UIButton) {
//        performSegue(withIdentifier: "profileSegue", sender: nil)
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    
//
//
//
//}
