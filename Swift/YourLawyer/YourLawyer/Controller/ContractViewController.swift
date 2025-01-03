//
//  ContractViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 28/12/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class ContractViewController: UIViewController {
    
    var lawyer: Lawyer?
    
    private let db = Firestore.firestore()
    
    private let serviceLabel = UILabel()
    private let priceLabel = UILabel()
    private let confirmButton = UIButton()
    private let returnButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lawyer = LawyerManager.shared.selectedLawyer
            // Do any additional setup after loading the view.
        setupUI()
    }
    private func setupUI(){
        returnButton.setTitle("Back", for: .normal)
        returnButton.setTitleColor(.black, for: .normal)
        returnButton.addTarget(self, action: #selector(returnAction), for: .touchUpInside)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(returnButton)
        
        
        serviceLabel.text = "Servicio de: \(lawyer?.name ?? "Abogado")"
        serviceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        serviceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(serviceLabel)

        // Precio del servicio
        priceLabel.text = "Precio: $\(lawyer?.hourlyRate ?? 0) por hora" // Ejemplo
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)

        // Botón de confirmación
        confirmButton.setTitle("Confirmar Contratación", for: .normal)
        confirmButton.backgroundColor = .systemGreen
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(confirmHire), for: .touchUpInside)
        view.addSubview(confirmButton)

        // Constraints
        NSLayoutConstraint.activate([
            serviceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            serviceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            priceLabel.topAnchor.constraint(equalTo: serviceLabel.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }

    
    
    @objc private func confirmHire() {
        guard let lawyerId = lawyer?.id else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }

        // Datos de la contratación
        let hireData: [String: Any] = [
            "lawyerId": lawyerId,
            "userId": userId,
            "timestamp": Timestamp(),
            "status": "Pendiente",
            "price": 1000 // Precio del servicio
        ]

        // Guarda la contratación en Firestore
        db.collection("hires").addDocument(data: hireData) { error in
            if let error = error {
                print("Error al registrar la contratación: \(error.localizedDescription)")
            } else {
                self.showConfirmationAlert()
            }
        }
    }

    private func showConfirmationAlert() {
        Utils.showMessage("Contratación Exitosa")
        let alert = UIAlertController(title: "Contratación Exitosa", message: "Has contratado a \(lawyer?.name ?? "el abogado") correctamente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    
    @objc private func returnAction(){
        dismiss(animated: true, completion: nil)
    }
    
    
}
