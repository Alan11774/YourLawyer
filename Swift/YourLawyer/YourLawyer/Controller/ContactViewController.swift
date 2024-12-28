//
//  ContactViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 28/12/24.
//

import UIKit
import Kingfisher

class ContactViewController: UIViewController {

    
    var lawyer: Lawyer?
    private var messages: [String] = []
    private let tableView = UITableView()
    private let messageInputBar = UIView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton()
    
//    private let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
    }
    
    private func setupUI() {
//            // Return
//        let returnButton = UIButton()
//        returnButton.backgroundColor = .systemBlue
//        view.addSubview(returnButton)
//        
//        returnButton.addTarget(self, action: #selector(returnAction), for: .touchUpInside)
            // Header
            let headerView = UIView()
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(headerView)
            
            let profileImageView = UIImageView()
            if let imageUrlString = lawyer?.imageURL, let imageUrl = URL(string: imageUrlString) {
                profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "person.circle"))
            } else {
                profileImageView.image = UIImage(systemName: "person.circle")
            }
            profileImageView.layer.cornerRadius = 20
            profileImageView.clipsToBounds = true
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(profileImageView)
            
            let nameLabel = UILabel()
            nameLabel.text = lawyer?.name
            
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(nameLabel)
        
        let returnButton = UIButton()
        returnButton.setTitle("Back", for: .normal)
        returnButton.setTitleColor(.black, for: .normal)
        returnButton.addTarget(self, action: #selector(returnAction), for: .touchUpInside)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(returnButton)
        
            
            // TableView
//            tableView.delegate = self
//            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
            
            tableView.separatorStyle = .none
            tableView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(tableView)
            
            // Message Input Bar
            messageInputBar.backgroundColor = .darkGray
            messageInputBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(messageInputBar)
            
            messageTextField.placeholder = "Type a message..."
            
            messageTextField.layer.cornerRadius = 5
            messageTextField.translatesAutoresizingMaskIntoConstraints = false
            messageInputBar.addSubview(messageTextField)
            
            sendButton.setTitle("Send", for: .normal)
            sendButton.setTitleColor(.green, for: .normal)
            sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            messageInputBar.addSubview(sendButton)
            
            // Constraints
        NSLayoutConstraint.activate([
             // Header
             headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             headerView.heightAnchor.constraint(equalToConstant: 60),
             
             profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
             profileImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
             profileImageView.widthAnchor.constraint(equalToConstant: 40),
             profileImageView.heightAnchor.constraint(equalToConstant: 40),
             
             nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
             nameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
             
             returnButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
             returnButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
             
             // TableView
             tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: messageInputBar.topAnchor),
             
             // Message Input Bar
             messageInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             messageInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             messageInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             messageInputBar.heightAnchor.constraint(equalToConstant: 50),
             
             messageTextField.leadingAnchor.constraint(equalTo: messageInputBar.leadingAnchor, constant: 16),
             messageTextField.centerYAnchor.constraint(equalTo: messageInputBar.centerYAnchor),
             messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
             messageTextField.heightAnchor.constraint(equalToConstant: 36),
             
             sendButton.trailingAnchor.constraint(equalTo: messageInputBar.trailingAnchor, constant: -16),
             sendButton.centerYAnchor.constraint(equalTo: messageInputBar.centerYAnchor),
         ])
        }
        
    @objc private func sendMessage(){
        print("Message to send")
    }
    @objc private func returnAction(){
        dismiss(animated: true, completion: nil)
    }
    

}
