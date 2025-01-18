//
//  AllLawyersViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 19/12/24.
//

import UIKit
import Kingfisher
import GoogleSignIn


class AllLawyersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
        
    // UI Components
    private let headerStackView = UIStackView()
    private let rightButtonsStackView = UIStackView()
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    private let filterButton = UIButton(type: .system)
    private let resultsLabel = UILabel()
    private let tableView = UITableView()
    private let logoutButton = UIButton(type: .system)
    private let userProfileImageView = UIButton()
    private let addCase = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

	var userRole: String = ""
    // Data Source
    private var lawyers: [Lawyer] = []
    private var filteredLawyers: [Lawyer] = []
	
	private var cases: [Case] = []
	private var filteredCases: [Case] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
		observeUserRole()
        
        
    }
	//*************************************************************************************
	// Logic for Clien and Lawyer sign up 
	//*************************************************************************************
	private func observeUserRole() {
		if (ProfileManager.shared.signedInProfile?.userRole == "Abogado"){
			setupUI()
			fetchLawyers()
			tableView.register(AllLawyersTableViewCell.self, forCellReuseIdentifier: "AllLawyersTableViewCell")
		}else{
			setupUI()
			fetchCases()
		}

	}
    
    private func setupUI() {
        
        headerStackView.axis = .horizontal
        headerStackView.alignment = .center
        headerStackView.distribution = .fill
        headerStackView.spacing = 8
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerStackView)
        // Profle
        userProfileImageView.setImage(UIImage(systemName: "person.circle"),for: .normal) // Imagen de ejemplo
        userProfileImageView.contentMode = .scaleToFill
        userProfileImageView.layer.cornerRadius = 30 // Ajusta el radio según el tamaño deseado
        userProfileImageView.clipsToBounds = true
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userProfileImageView)
        userProfileImageView.addTarget(self, action: #selector(profileView), for: .touchUpInside)
        
        
        rightButtonsStackView.axis = .horizontal
        rightButtonsStackView.alignment = .center
        rightButtonsStackView.spacing = 8
        rightButtonsStackView.translatesAutoresizingMaskIntoConstraints = false

        
        // AddCase
        addCase.setImage(UIImage(systemName: "plus"),for: .normal) // Imagen de ejemplo
        addCase.contentMode = .scaleToFill
        addCase.layer.cornerRadius = 30 // Ajusta el radio según el tamaño deseado
        addCase.clipsToBounds = true
        addCase.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addCase)
        addCase.addTarget(self, action: #selector(handleAddCase), for: .touchUpInside)
        
        // Logout
        logoutButton.setImage(UIImage(systemName: "iphone.and.arrow.right.outward"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        rightButtonsStackView.addArrangedSubview(addCase)
        rightButtonsStackView.addArrangedSubview(logoutButton)
        
        headerStackView.addArrangedSubview(userProfileImageView)
        headerStackView.addArrangedSubview(rightButtonsStackView)
        
        
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
        
        activityIndicator.color = .gray
        activityIndicator.style = .medium
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        // Agregar constraints
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerStackView.heightAnchor.constraint(equalToConstant: 50),
            
            userProfileImageView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor, constant: 16),
            userProfileImageView.topAnchor.constraint(equalTo: headerStackView.topAnchor, constant: 16),
            userProfileImageView.widthAnchor.constraint(equalTo: headerStackView.heightAnchor),
            userProfileImageView.heightAnchor.constraint(equalTo: userProfileImageView.widthAnchor),
            
            addCase.widthAnchor.constraint(equalTo: headerStackView.heightAnchor),
            addCase.heightAnchor.constraint(equalTo: addCase.widthAnchor),
            
            logoutButton.widthAnchor.constraint(equalTo: headerStackView.heightAnchor),
            logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
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
	
	
	//*************************************************************************************
	// Send information for next view controller
	//*************************************************************************************
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		   if segue.identifier == "detailLawyerSegue" {
			   if let indexPath = tableView.indexPathForSelectedRow {
				   let lawyer = lawyers[indexPath.row]
				   LawyerManager.shared.selectedLawyer = lawyer // Singleton
			   }
		   }
	   }

	//*************************************************************************************
	// Delegates for table views
	//*************************************************************************************
	
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "detailLawyerSegue", sender: nil)
        }
        // MARK: - UITableViewDataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredLawyers.count // Mostrar solo los abogados filtrados
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllLawyersTableViewCell", for: indexPath) as? AllLawyersTableViewCell else {
                return UITableViewCell()
            }

            // Configurar la celda con los datos filtrados
            let lawyer = filteredLawyers[indexPath.row]
            cell.titleLabel.text = lawyer.name
            cell.subtitleLabel.text = lawyer.description

            // Configurar imagen
            if let imageUrlString = lawyer.imageURL, let imageUrl = URL(string: imageUrlString) {
                cell.profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "person.crop.circle.fill"))
            } else {
                cell.profileImageView.image = UIImage(named: "person.crop.circle.fill")
            }

            return cell
        }
	//*************************************************************************************
	// Obtain apiari information.
	//*************************************************************************************
	
	func fetchCases() {
		activityIndicator.startAnimating()
		CasesService.shared.fetchCases { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let cases):
					self?.cases = cases
					self?.filteredCases = cases
					self?.tableView.reloadData()
					self?.resultsLabel.text = "\(self?.filteredCases.count ?? 0) Resultados encontrados"
					self?.activityIndicator.stopAnimating()
				case .failure(let error):
					print("Error al obtener casos: \(error)")
					self?.activityIndicator.stopAnimating()
				}
			}
		}
	}
	
	
	private func fetchLawyers() {
		activityIndicator.startAnimating()
		LawyersService.shared.fetchLawyers { [weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success(let lawyers):
					self?.lawyers = lawyers
					self?.filteredLawyers = lawyers // Mostrar todos inicialmente
					self?.tableView.reloadData()
					self?.resultsLabel.text = "\(self?.filteredLawyers.count ?? 0) Resultados encontrados"
					self?.activityIndicator.stopAnimating()
				case .failure(let error):
					print("Error al obtener abogados: \(error)")
					self?.activityIndicator.stopAnimating()
				}
			}
		}
	}

	//*************************************************************************************
	// Filter search
	//*************************************************************************************
	
	@objc private func searchFilter() {
		guard let searchText = searchTextField.text, !searchText.isEmpty else {
			// Mostrar todos los abogados si no hay texto de búsqueda
			filteredLawyers = lawyers
			resultsLabel.text = "\(filteredLawyers.count) Resultados encontrados"
			tableView.reloadData()
			return
		}

		// Filtrar los abogados según el texto ingresado
		filteredLawyers = lawyers.filter { lawyer in
			lawyer.name.lowercased().contains(searchText.lowercased()) ||
			lawyer.description.lowercased().contains(searchText.lowercased())
		}

		// Actualizar etiqueta de resultados
		resultsLabel.text = "\(filteredLawyers.count) Resultados encontrados para '\(searchText)'"
		tableView.reloadData()
	}
	
	
	//*************************************************************************************
	// Add Case button
	//*************************************************************************************
    
    @objc private func handleAddCase() {
        self.performSegue(withIdentifier: "postCaseSegue", sender: nil)
    }
    
	
	
	//*************************************************************************************
	// Logout
	//*************************************************************************************
	@objc private func handleLogout() {
		
		let alert = UIAlertController(title: "Cerrar sesión", message: "¿Estás seguro de que desea cerrar sesión?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in

				LoginManager.shared.logout{ result  in
					switch result {
					case .success:
						ProfileManager.shared.signedInProfile = nil
						Utils.showMessage("Sesion cerrada Exitosamente")
						self.dismiss(animated: true)
					case .failure(let error):
						Utils.showMessage("Ocurrio un error al cerrar la sesión \(error.localizedDescription)")
				}
				
			}
			
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel))
		present(alert,animated: true)

	}
	
	//*************************************************************************************
	// User Profile View
	//*************************************************************************************
    
    @objc private func profileView(){
        self.performSegue(withIdentifier: "profileSegue", sender: nil)
    }
}
