//
//  MessageCellTableViewCell.swift
//  YourLawyer
//
//  Created by Alan Ulises on 28/12/24.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {


    private let messageLabel = UILabel()
    private let bubbleBackgroundView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)

        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),

            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with message: String) {
        messageLabel.text = message
        if message.starts(with: "You:") {
            bubbleBackgroundView.backgroundColor = UIColor.systemBlue
            messageLabel.textColor = .white
            messageLabel.textAlignment = .right
        } else {
            bubbleBackgroundView.backgroundColor = UIColor.systemGray
            messageLabel.textColor = .white
            messageLabel.textAlignment = .left
        }
    }

}
