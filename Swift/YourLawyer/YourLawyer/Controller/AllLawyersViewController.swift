//
//  AllLawyersViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 19/12/24.
//

import UIKit
import Kingfisher


class AllLawyersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        // UI Components
        private let searchTextField = UITextField()
        private let searchButton = UIButton(type: .system)
        private let filterButton = UIButton(type: .system)
        private let resultsLabel = UILabel()
        private let tableView = UITableView()
        private let logoutButton = UIButton(type: .system)
    
        
        // Data Source
        private var lawyers: [Lawyer] = []
//        private var results: [String] = ["Result 1", "Result 2", "Result 3", "Result 4", "Result 5", "Result 6", "Result 7", "Result 8", "Result 9", "Result 10", "Result 11", "Result 12", "Result 13", "Result 14", "Result 15", "Result 16", "Result 17", "Result 18", "Result 19", "Result 20", "Result 21", "Result 22", "Result 23", "Result 24", "Result 25", "Result 26", "Result 27"] // Datos de ejemplo
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            
            setupUI()

            fetchLawyers()
            tableView.register(AllLawyersTableViewCell.self, forCellReuseIdentifier: "AllLawyersTableViewCell")
            
        }
        
        private func setupUI() {
            // Configurar campo de búsqueda
            searchTextField.placeholder = "Ingresa un texto para buscar"
            searchTextField.borderStyle = .roundedRect
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(searchTextField)
            
            // Configurar botón de búsqueda
            searchButton.setTitle("Buscar", for: .normal)
            searchButton.backgroundColor = .systemBlue
            searchButton.setTitleColor(.white, for: .normal)
            searchButton.layer.cornerRadius = 8
            searchButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(searchButton)
            searchButton.addTarget(self, action: #selector(searchFilter), for: .touchUpInside)
            
            // Configurar etiqueta de resultados
            
            resultsLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            resultsLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(resultsLabel)
            
            // Configurar botón de filtro
            filterButton.setTitle("Price low to high", for: .normal)
            filterButton.setTitleColor(.systemBlue, for: .normal)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(filterButton)
            
            
            // Configurar tabla
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AllLawyersTableViewCell")
            tableView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tableView)
            
            // Agregar constraints
            NSLayoutConstraint.activate([
                searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
                searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                searchButton.heightAnchor.constraint(equalToConstant: 44),
                
                resultsLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 24),
                resultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                
                filterButton.centerYAnchor.constraint(equalTo: resultsLabel.centerYAnchor),
                filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                tableView.topAnchor.constraint(equalTo: resultsLabel.bottomAnchor, constant: 16),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        // MARK: - UITableViewDataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return lawyers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Reutilizar la celda personalizada
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllLawyersTableViewCell", for: indexPath) as? AllLawyersTableViewCell else {
                return UITableViewCell()
            }

            // Configurar la celda con datos de ejemplo
            let lawyer = lawyers[indexPath.row]
            cell.titleLabel.text = lawyer.name//"Project Title \(indexPath.row + 1)"
            cell.subtitleLabel.text = lawyer.description//"This is the description of project \(indexPath.row + 1)."
            
            // Imagen de ejemplo
            if let imageUrlString = lawyer.imageURL, let imageUrl = URL(string: imageUrlString) {
                  cell.profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "person.crop.circle.fill"))
                } else {
                  cell.profileImageView.image = UIImage(named: "person.crop.circle.fill")
                }

            return cell
        }
    
        private func fetchLawyers() {
            LawyersService.shared.fetchLawyers { [weak self] result in
                   DispatchQueue.main.async {
                       switch result {
                       case .success(let projects):
                           self?.lawyers = projects
                           self?.tableView.reloadData()
                           self?.resultsLabel.text = self?.lawyers.count.description
                           
                       case .failure(let error):
                           print("Error al obtener proyectos: \(error)")
                       }
                   }
               }
           }
    
        private func updateResultsLabel(count: Int) {
          resultsLabel.text = "\(count) search result(s) found"
        }
    
        @objc private func searchFilter(){
            print(searchTextField.text!)
        }
    
        @objc private func handleLogout() {
            // Present confirmation dialog or handle logout logic here
            print("Logout button pressed")
          }
}
