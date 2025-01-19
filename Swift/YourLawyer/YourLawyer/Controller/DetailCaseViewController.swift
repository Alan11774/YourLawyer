//
//  DetailCaseViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 18/01/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

class DetailCaseViewController: UIViewController {
	var selectedCase: Case?
	let email = Auth.auth().currentUser?.email ?? ""
	let db = Firestore.firestore()
	private var casePurchasing = ""
	
	private var locationStack = UIStackView()
	private var budgetStack = UIStackView()
	private var postedByStack = UIStackView()
	private var urgencyStack = UIStackView()
	
	private var requirementsLabel = UILabel()
	private var requirementsStack = UIStackView()
	
	private var tagsLabel = UILabel()
	private var tagsStack = UIStackView()
	private var proposalButtonsStack = UIStackView()
	private var applyButton = UIButton(type: .system)
	
	
	private var budgetProposalLabel = UILabel()
	private var proposalBudget = UITextField()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		selectedCase = CaseManager.shared.selectedCase
		setupUI()
        // Do any additional setup after loading the view.
    }
    

	private func setupUI(){
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(scrollView)
		
		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(contentView)
		
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
		
		// Profile Image
		let caseImageView = UIImageView()
		caseImageView.translatesAutoresizingMaskIntoConstraints = false
		if let imageUrlString = selectedCase?.imageURL, let imageUrl = URL(string: imageUrlString) {
			caseImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "person.circle"))
		} else {
			caseImageView.image = UIImage(systemName: "photo")
		}
		caseImageView.contentMode = .scaleAspectFill
		contentView.addSubview(caseImageView)
		

		contentView.addSubview(caseImageView)
		NSLayoutConstraint.activate([
		
			caseImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			caseImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
			caseImageView.widthAnchor.constraint(equalToConstant: 100),
			caseImageView.heightAnchor.constraint(equalToConstant: 100)
		])
		caseImageView.layer.cornerRadius = caseImageView.frame.height / 2
		caseImageView.layer.masksToBounds = true
		
		// Title Label
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.text = selectedCase?.title
		titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
		titleLabel.textAlignment = .center
		contentView.addSubview(titleLabel)
		
		// Category Label
		let categoryLabel = UILabel()
		categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		categoryLabel.text = selectedCase?.category
		categoryLabel.font = UIFont.systemFont(ofSize: 16)
		categoryLabel.textColor = .gray
		categoryLabel.textAlignment = .center
		contentView.addSubview(categoryLabel)
		
		// Description Label
		let descriptionLabel = UILabel()
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.text = selectedCase?.description
		descriptionLabel.numberOfLines = 0
		descriptionLabel.font = UIFont.systemFont(ofSize: 16)
		descriptionLabel.textAlignment = .center
		contentView.addSubview(descriptionLabel)
		
		// Location Section
		locationStack = createIconWithLabel(iconName: "mappin.and.ellipse", text: selectedCase?.location ?? "Not set")
		contentView.addSubview(locationStack)
		
		// Budget Section
		budgetStack = createIconWithLabel(iconName: "dollarsign", text: selectedCase?.budget ?? "Budget not set")
		contentView.addSubview(budgetStack)
		
		// Posted By Section
		postedByStack = createIconWithLabel(iconName: "person.circle", text: selectedCase?.postedBy ?? "Desconocido")
		contentView.addSubview(postedByStack)
		
		// Urgency Section
		urgencyStack = createIconWithLabel(iconName: "flame", text: selectedCase?.details.urgency ?? "Urgency not set")
		contentView.addSubview(urgencyStack)
		
		
		
		requirementsLabel.translatesAutoresizingMaskIntoConstraints = false
		requirementsLabel.text = "Entregables requeridos:"
		requirementsLabel.numberOfLines = 0
		requirementsLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		requirementsLabel.textAlignment = .center
		contentView.addSubview(requirementsLabel)
		
		// Tags Section
		let requirement1 = createIconWithLabel(iconName: "folder", text: selectedCase?.details.requirements[0] ?? "Requerimiento no seteado")
		let requirement2 = createIconWithLabel(iconName: "folder", text: selectedCase?.details.requirements[1] ?? "Requerimiento no seteado")
		
		requirementsStack = UIStackView(arrangedSubviews: [requirement1, requirement2])
		requirementsStack.axis = .vertical
		requirementsStack.spacing = 8
		requirementsStack.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(requirementsStack)
		
		
		
		tagsLabel.translatesAutoresizingMaskIntoConstraints = false
		tagsLabel.text = "Tags:"
		tagsLabel.numberOfLines = 0
		tagsLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		
		contentView.addSubview(tagsLabel)
			// Tags Section
		let tag1 = createIconWithLabel(iconName: "smallcircle.filled.circle", text: selectedCase?.details.tags[0] ?? "No seteado")
		let tag2 = createIconWithLabel(iconName: "smallcircle.filled.circle", text: selectedCase?.details.tags[1] ?? "No seteado")
		let tag3 = createIconWithLabel(iconName: "smallcircle.filled.circle", text: selectedCase?.details.tags[2] ?? "No seteado")
		
		tagsStack = UIStackView(arrangedSubviews: [tag1, tag2, tag3])
		tagsStack.axis = .vertical
		tagsStack.spacing = 8
		tagsStack.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(tagsStack)
		
		// Apply Button
		applyButton = UIButton(type: .system)
		applyButton.translatesAutoresizingMaskIntoConstraints = false
		applyButton.setTitle("Aplicar", for: .normal)
		applyButton.backgroundColor = .blue
		applyButton.setTitleColor(.white, for: .normal)
		applyButton.layer.cornerRadius = 8
		contentView.addSubview(applyButton)
		
		// Constraints
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: caseImageView.bottomAnchor, constant: 16),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
			categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
			descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			locationStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
			locationStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			locationStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			budgetStack.topAnchor.constraint(equalTo: locationStack.bottomAnchor, constant: 16),
			budgetStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			budgetStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			postedByStack.topAnchor.constraint(equalTo: budgetStack.bottomAnchor, constant: 16),
			postedByStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			postedByStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			urgencyStack.topAnchor.constraint(equalTo: postedByStack.bottomAnchor, constant: 16),
			urgencyStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			urgencyStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			requirementsLabel.topAnchor.constraint(equalTo: urgencyStack.bottomAnchor, constant: 16),
			requirementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			requirementsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			requirementsStack.topAnchor.constraint(equalTo: requirementsLabel.bottomAnchor, constant: 16),
			requirementsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			requirementsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
						
			tagsLabel.topAnchor.constraint(equalTo: requirementsStack.bottomAnchor, constant: 16),
			tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			tagsStack.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 16),
			tagsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			tagsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			
			applyButton.topAnchor.constraint(equalTo: tagsStack.bottomAnchor, constant: 32),
			applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
			applyButton.heightAnchor.constraint(equalToConstant: 50)
		])
		
		
		
		budgetProposalLabel.translatesAutoresizingMaskIntoConstraints = false
		budgetProposalLabel.text = "Ingresa un presupuesto en este rango: $\(selectedCase?.budget ?? "0.00 MXN")"
		budgetProposalLabel.numberOfLines = 0
		budgetProposalLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		budgetProposalLabel.textAlignment = .center
		
		
		proposalBudget.placeholder = "Ingresa tu presupuesto 0-999999 MXN"
		
		let publishButton = UIButton(type: .system)
		publishButton.translatesAutoresizingMaskIntoConstraints = false
		publishButton.setTitle("Publicar propuesta", for: .normal)
		publishButton.backgroundColor = .green
		publishButton.setTitleColor(.white, for: .normal)
		publishButton.layer.cornerRadius = 8
		
		
		let cancelButton = UIButton(type: .system)
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		cancelButton.setTitle("Cancelar", for: .normal)
		cancelButton.backgroundColor = .red
		cancelButton.setTitleColor(.white, for: .normal)
		cancelButton.layer.cornerRadius = 8
		
		
		proposalButtonsStack = UIStackView(arrangedSubviews: [budgetProposalLabel,proposalBudget,publishButton, cancelButton])
		proposalButtonsStack.axis = .vertical
		proposalButtonsStack.spacing = 12
		proposalButtonsStack.translatesAutoresizingMaskIntoConstraints = false
		proposalButtonsStack.isHidden = true
		contentView.addSubview(proposalButtonsStack)
		
		NSLayoutConstraint.activate([
			proposalButtonsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
			proposalButtonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			proposalButtonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
		])
		
		applyButton.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
		publishButton.addTarget(self, action: #selector(publishAction), for: .touchUpInside)
		cancelButton.addTarget(self, action: #selector(cancelActionButton), for: .touchUpInside)
	}
	
	private func createIconWithLabel(iconName: String, text: String) -> UIStackView {
		let iconImageView = UIImageView()
		iconImageView.image = UIImage(systemName: iconName)
		iconImageView.contentMode = .scaleAspectFit
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
		
		let label = UILabel()
		label.text = text
		label.font = UIFont.systemFont(ofSize: 14)
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		
		let stack = UIStackView(arrangedSubviews: [iconImageView, label])
		stack.axis = .horizontal
		stack.spacing = 8
		stack.translatesAutoresizingMaskIntoConstraints = false
		
		return stack
	}
	
	@objc private func applyAction(){
		locationStack.isHidden = true
		budgetStack.isHidden = true
		postedByStack.isHidden = true
		urgencyStack.isHidden = true
		requirementsLabel.isHidden = true
		requirementsStack.isHidden = true
		tagsLabel.isHidden = true
		tagsStack.isHidden = true
		requirementsStack.isHidden = true
		applyButton.isHidden = true
		
		proposalButtonsStack.isHidden = false
		
		
	}
	@objc private func publishAction(){
		
		if let value = proposalBudget.text {
			// Obtén el texto del UILabel
			if let range = selectedCase?.budget {
				// Divide el rango en componentes y filtra valores válidos
				let rangeList = range
					.components(separatedBy: CharacterSet(charactersIn: " -MXN"))
					.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
					.compactMap { Int($0) } // Convierte a enteros
				
				// Ahora `rangeList` contiene los valores del rango como enteros
				print("Valor ingresado: \(value)")
				print("Rango: \(rangeList)") // Ejemplo: [0, 10000]
				let min = rangeList.first ?? 0
				let max = rangeList.last ?? 0
					// Verifica si el valor está dentro del rango
				if (min...max).contains(Int(value) ?? 0) {
					Utils.showMessage("El valor ingresado \(value) está dentro del ppresupuesto \(min) - \(max).")
					locationStack.isHidden = false
					budgetStack.isHidden = false
					postedByStack.isHidden = false
					urgencyStack.isHidden = false
					requirementsLabel.isHidden = false
					requirementsStack.isHidden = false
					tagsLabel.isHidden = false
					tagsStack.isHidden = false
					requirementsStack.isHidden = false
					
					applyButton.isHidden = true
					proposalButtonsStack.isHidden = true
					
				} else {
					Utils.showMessage("El valor ingresado \(value) está fuera del presupuesto  \(min) - \(max).")
				}
			}
		}else{
			Utils.showMessage("Por favor ingresa un numero en el rango de \(selectedCase?.budget ?? "Error no hay un rango")")
		}
		
	}
	@objc private func cancelActionButton(){
		locationStack.isHidden = false
		budgetStack.isHidden = false
		postedByStack.isHidden = false
		urgencyStack.isHidden = false
		requirementsLabel.isHidden = false
		requirementsStack.isHidden = false
		tagsLabel.isHidden = false
		tagsStack.isHidden = false
		requirementsStack.isHidden = false
		applyButton.isHidden = false
		
		proposalButtonsStack.isHidden = true
	}
	
	
//	
//	func postInFirebase() {
//
//		// Datos a actualizar
//		let updatedData: [String: Any?] = [
//			"caseId": selectedCase?.caseId ?? "Not set",
//			"budget": selectedCase?.budget ?? "Not set",
//			"proposedBudget": proposalBudget.text ?? "Not set",
//			"title": selectedCase?.title ?? "Not set",
//			"caseDescription": selectedCase?.description ?? "Not set",
//			"requirements": [selectedCase?.details.requirements[0] ?? "Not set", selectedCase?.details.requirements[1] ?? "Not set"].compactMap { $0 },
//			"tags": [selectedCase?.details.tags[0], selectedCase?.details.tags[1], selectedCase?.details.tags[2]].compactMap { $0 },
//			"status": casePurchasing,
//			"clientEmail": selectedCase?.postedBy,
//			"lawyerEmail": email
//		].compactMapValues { $0 } // Elimina valores nulos
//
//		// Referencia al documento del perfil
//		let profileDocRef = Firestore.firestore()
//			.collection("users")
//			.document(email)
//			.collection("cases")
//			.document(selectedCase.caseId)
//
//		profileDocRef.getDocument { document, error in
//			if let error = error {
//				Utils.showMessage("Error al verificar el perfil: \(error.localizedDescription)")
//				return
//			}
//
//			if let document = document, document.exists {
//				// Si el documento ya existe, actualiza los datos
//				profileDocRef.updateData(updatedData) { error in
//					if let error = error {
//						Utils.showMessage("Error al actualizar el perfil: \(error.localizedDescription)")
//					} else {
//						Utils.showMessage("Perfil actualizado exitosamente")
//					}
//				}
//			} else {
//				// Si el documento no existe, crea uno nuevo
//				profileDocRef.setData(updatedData) { error in
//					if let error = error {
//						Utils.showMessage("Error al crear el perfil: \(error.localizedDescription)")
//					} else {
//						Utils.showMessage("Perfil creado exitosamente")
//					}
//				}
//			}
//		}
//	}
//	
//	func getCaseStatus() {
//
//		// Referencia al documento del perfil
//		let profileDocRef = Firestore.firestore()
//			.collection("users")
//			.document(email)
//			.collection("cases")
//			.document(selectedCase.caseId)
//
//		profileDocRef.getDocument { document, error in
//			if let error = error {
//				Utils.showMessage("Error al verificar el perfil: \(error.localizedDescription)")
//				return
//			}
//
//			if let document = document, document.exists {
//				casePurchasing = document.get("status") as? String ?? ""
//				let clientEmail = document.get("clientEmail") as? String
//
//				if casePurchasing == "Accepted", clientEmail == self.postedByLabel.text {
//					print("Aceptado")
////					self.finalBudgetProposalTextView.isHidden = false
////					self.finalBudgetProposalTextView.text = "Presupuesto aceptado"
////					self.applyButton.isHidden = true
////					
//				} else if casePurchasing == "Rejected", clientEmail == self.postedByLabel.text {
//					print("Rechazado")
////					self.finalBudgetProposalTextView.isHidden = false
////					self.finalBudgetProposalTextView.text = "Presupuesto Rechazado"
////					self.applyButton.isHidden = true
////					self.submitApplyButton.isHidden = true
//				} else if casePurchasing == "Waiting Approval", clientEmail == self.postedByLabel.text {
//					print("Esperando aprobacion")
////					self.finalBudgetProposalTextView.isHidden = false
////					self.finalBudgetProposalTextView.text = "Esperando aprobación del cliente"
////					self.applyButton.isHidden = true
//				}
//			}
//		}
//	}
}
