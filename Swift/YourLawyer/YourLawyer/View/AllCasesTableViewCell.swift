//
//  AllCasesTableViewCell.swift
//  YourLawyer
//
//  Created by Alan Ulises on 18/01/25.
//

import UIKit

class AllCasesTableViewCell: UITableViewCell {
	
	let profileImageView = UIImageView()
	let descriptionLabel = UILabel()
	let budgetLabel = UILabel()

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
//	required init?(coder: NSCoder) {
//		super.init(coder: coder)
//		setupUI()
//	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func setupUI(){
		contentView.backgroundColor = .white
		// *********************************************************************************
		// Profile
		// *********************************************************************************
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		profileImageView.contentMode = .scaleAspectFit
		profileImageView.image = UIImage(systemName: "photo")
		profileImageView.clipsToBounds = true
		profileImageView.layer.cornerRadius = 8
		contentView.addSubview(profileImageView)
		
		NSLayoutConstraint.activate([
			profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			profileImageView.heightAnchor.constraint(equalToConstant: 250)
		])
		
		// *********************************************************************************
		// Vertical Stack View
		// *********************************************************************************
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.font = UIFont.boldSystemFont(ofSize: 16)
		descriptionLabel.textColor = .black
		descriptionLabel.text = "Title"
		descriptionLabel.numberOfLines = 2
		descriptionLabel.lineBreakMode = .byTruncatingTail
		
		
		budgetLabel.translatesAutoresizingMaskIntoConstraints = false
		budgetLabel.font = UIFont.systemFont(ofSize: 14)
		budgetLabel.text = "0.0"
		budgetLabel.textColor = .gray
		budgetLabel.textAlignment = .right
		
		
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 8
		stackView.alignment = .fill
		contentView.addSubview(stackView)
		stackView.addArrangedSubview(descriptionLabel)
		stackView.addArrangedSubview(budgetLabel)
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
			stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
		])
		
		
	}

}
