//
//  DetailCaseViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 18/01/25.
//

import UIKit

class DetailCaseViewController: UIViewController {
	var selectedCase: Case?

    override func viewDidLoad() {
        super.viewDidLoad()
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
					scrollView.topAnchor.constraint(equalTo: view.topAnchor),
					scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
					scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
					scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
					
					contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
					contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
					contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
					contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
					contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
				])
				
				// Profile Image
				let caseImageView = UIImageView()
				caseImageView.translatesAutoresizingMaskIntoConstraints = false
				caseImageView.image = UIImage(named: "legal")
				caseImageView.contentMode = .scaleAspectFit
				contentView.addSubview(caseImageView)
				
				// Title Label
				let titleLabel = UILabel()
				titleLabel.translatesAutoresizingMaskIntoConstraints = false
				titleLabel.text = "Nombre del Caso"
				titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
				titleLabel.textAlignment = .center
				contentView.addSubview(titleLabel)
				
				// Category Label
				let categoryLabel = UILabel()
				categoryLabel.translatesAutoresizingMaskIntoConstraints = false
				categoryLabel.text = "Categoría"
				categoryLabel.font = UIFont.systemFont(ofSize: 16)
				categoryLabel.textColor = .gray
				categoryLabel.textAlignment = .center
				contentView.addSubview(categoryLabel)
				
				// Description Label
				let descriptionLabel = UILabel()
				descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
				descriptionLabel.text = "Descripción breve del abogado"
				descriptionLabel.font = UIFont.systemFont(ofSize: 16)
				descriptionLabel.textAlignment = .center
				contentView.addSubview(descriptionLabel)
				
				// Location Section
				let locationStack = createIconWithLabel(iconName: "location_resource", text: "Información detallada sobre el abogado.")
				contentView.addSubview(locationStack)
				
				// Budget Section
				let budgetStack = createIconWithLabel(iconName: "money_resource", text: "Presupuesto")
				contentView.addSubview(budgetStack)
				
				// Posted By Section
				let postedByStack = createIconWithLabel(iconName: "person_resource", text: "Posteado por: Juan Mecánico el día 19/02/2024")
				contentView.addSubview(postedByStack)
				
				// Urgency Section
				let urgencyStack = createIconWithLabel(iconName: "fire_resource", text: "Urgencia")
				contentView.addSubview(urgencyStack)
				
				// Tags Section
				let tag1 = createTagView(tagText: "Tag1")
				let tag2 = createTagView(tagText: "Tag2")
				let tag3 = createTagView(tagText: "Tag3")
				
				let tagsStack = UIStackView(arrangedSubviews: [tag1, tag2, tag3])
				tagsStack.axis = .vertical
				tagsStack.spacing = 8
				tagsStack.translatesAutoresizingMaskIntoConstraints = false
				contentView.addSubview(tagsStack)
				
				// Apply Button
				let applyButton = UIButton(type: .system)
				applyButton.translatesAutoresizingMaskIntoConstraints = false
				applyButton.setTitle("Aplicar", for: .normal)
				applyButton.backgroundColor = .blue
				applyButton.setTitleColor(.white, for: .normal)
				applyButton.layer.cornerRadius = 8
				contentView.addSubview(applyButton)
				
				// Constraints
				NSLayoutConstraint.activate([
					caseImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
					caseImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
					caseImageView.widthAnchor.constraint(equalToConstant: 100),
					caseImageView.heightAnchor.constraint(equalToConstant: 100),
					
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
					
					tagsStack.topAnchor.constraint(equalTo: urgencyStack.bottomAnchor, constant: 16),
					tagsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
					tagsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
					
					applyButton.topAnchor.constraint(equalTo: tagsStack.bottomAnchor, constant: 32),
					applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
					applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
					applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
					applyButton.heightAnchor.constraint(equalToConstant: 50)
				])
	}
	
	private func createIconWithLabel(iconName: String, text: String) -> UIStackView {
		let iconImageView = UIImageView()
		iconImageView.image = UIImage(named: iconName)
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
	
	private func createTagView(tagText: String) -> UILabel {
		let tagLabel = UILabel()
		tagLabel.text = tagText
		tagLabel.font = UIFont.italicSystemFont(ofSize: 14)
		tagLabel.textColor = .blue
		return tagLabel
	}
}
