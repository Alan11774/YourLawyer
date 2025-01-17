//
//  ContractViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 28/12/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Kingfisher


class ContractViewController: UIViewController {
    
    var lawyer: Lawyer?
    
    private let db = Firestore.firestore()
    
	private var scrollView = UIScrollView()
	private var contentView = UIView()
	private var stackView = UIStackView()
	
	private var cardImageView = UIImageView()
	private var lawyerNameLabel = UILabel()
	private var categoryLabel = UILabel()
	private var descriptionLabel = UILabel()
	private var priceLabel = UILabel()
	private var bankInformationTitleLabel = UILabel()
	
	private var continueButton = UIButton(type: .system)
	private var cancelButton = UIButton(type: .system)
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "stripeSegue" {
			if let stripeVC = segue.destination as? StripeViewController {
				stripeVC.lawyer = lawyer
			}
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lawyer = LawyerManager.shared.selectedLawyer
            // Do any additional setup after loading the view.
        setupUI()
    }
    private func setupUI(){
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
		let url = URL(string: creditCardGif)!

		cardImageView.contentMode = .scaleAspectFill // Cambiado para mejor ajuste
		cardImageView.clipsToBounds = true
		cardImageView.kf.setImage(with: url)
		cardImageView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(cardImageView)
		NSLayoutConstraint.activate([
		
			cardImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
			cardImageView.widthAnchor.constraint(equalToConstant: 200),
			cardImageView.heightAnchor.constraint(equalToConstant: 200)
		])
		
			// Content Stack
		stackView.axis = .vertical
		stackView.spacing = 22
		stackView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(stackView)
		

		NSLayoutConstraint.activate([
				// Constraints para el stackView
			stackView.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 16),
				stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
				stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
				stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
		])
		
		lawyerNameLabel.text = "Contratando a : \(lawyer?.name ?? "Not Set")"
		lawyerNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
		stackView.addArrangedSubview(lawyerNameLabel)
		
		categoryLabel.text = "Descipción del servicio: \(lawyer?.description ?? "Not set Description")"
		stackView.addArrangedSubview(categoryLabel)
		
		descriptionLabel.text = "Descripción del perfil: \(lawyer?.userDescription ?? "Not set lawyer description")"
		descriptionLabel.numberOfLines = 0
		stackView.addArrangedSubview(descriptionLabel)
		
		priceLabel.text = "Costo $ \(lawyer?.hourlyRate ?? 0.00) MXN"
		priceLabel.textColor = .green
		priceLabel.layer.borderColor = UIColor.black.cgColor
		priceLabel.layer.borderWidth = 0.5
		priceLabel.font = .systemFont(ofSize: 22, weight: .bold)
		stackView.addArrangedSubview(priceLabel)
		
		bankInformationTitleLabel.text = "Ingresa tus datos bancarios"
		bankInformationTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
		bankInformationTitleLabel.textAlignment = .center
		stackView.addArrangedSubview(bankInformationTitleLabel)
		
		continueButton.setTitle("Continuar", for: .normal)
		continueButton.backgroundColor = .systemBlue
		continueButton.setTitleColor(.white, for: .normal)
		continueButton.layer.cornerRadius = 8
		continueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		stackView.addArrangedSubview(continueButton)
		
		cancelButton.setTitle("Cancelar", for: .normal)
		cancelButton.backgroundColor = .systemRed
		cancelButton.setTitleColor(.white, for: .normal)
		cancelButton.layer.cornerRadius = 8
		cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		stackView.addArrangedSubview(cancelButton)
		
		cancelButton.addTarget(self, action: #selector(returnAction), for: .touchUpInside)
		continueButton.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
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
        
	@objc private func continueAction(){
		self.performSegue(withIdentifier: "stripeSegue", sender: nil)
    }
    

	
}
