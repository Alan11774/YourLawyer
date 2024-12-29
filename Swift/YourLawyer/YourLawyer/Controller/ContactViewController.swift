//
//  ContactViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 28/12/24.
//

import UIKit
import Kingfisher
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var lawyer: Lawyer?
    private var messages: [String] = []
    private let tableView = UITableView()
    private let messageInputBar = UIView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton()
    
    
    private let headerView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let returnButton = UIButton()
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lawyer = LawyerManager.shared.selectedLawyer
        setupUI()
        tableView.register(MessageCellTableViewCell.self, forCellReuseIdentifier: "MessageCellTableViewCell") 
        loadMessages()
        
    }
    
    private func setupUI() {

            
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
            

        if let imageUrlString = lawyer?.imageURL, let imageUrl = URL(string: imageUrlString) {
                profileImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "person.circle"))
            } else {
                profileImageView.image = UIImage(systemName: "person.circle")
            }
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(profileImageView)

        nameLabel.text = lawyer?.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(nameLabel)
    
        returnButton.setTitle("Back", for: .normal)
        returnButton.setTitleColor(.black, for: .normal)
        returnButton.addTarget(self, action: #selector(returnAction), for: .touchUpInside)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(returnButton)
        
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCellTableViewCell")
        
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Message Input Bar
        messageInputBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageInputBar)
        
        messageTextField.placeholder = "Escribe tu mensaje..."
        messageTextField.layer.cornerRadius = 5
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageInputBar.addSubview(messageTextField)
        
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
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
        
    
    @objc private func returnAction(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendMessage() {
        guard let text = messageTextField.text, !text.isEmpty else { return }
        guard let clientId = Auth.auth().currentUser?.email else { return } // Obtenemos el correo del cliente actual
        guard let lawyerId = lawyer?.id else { return } // ID del abogado seleccionado
        
        let messageData: [String: Any] = [
            "text": text,
            "timestamp": Timestamp(),
            "senderId": clientId, // Cliente que envía el mensaje
            "receiverId": lawyerId // Abogado que recibe el mensaje
        ]
        
        db.collection("messages").document(clientId).collection(String(lawyerId)).addDocument(data: messageData) { error in
            if let error = error {
                print("Error al enviar el mensaje: \(error.localizedDescription)")
            } else {
                self.messageTextField.text = ""
            }
        }
    }

    private func loadMessages() {
        guard let clientId = Auth.auth().currentUser?.email else { return } // Correo del cliente actual
        guard let lawyerId = lawyer?.id else { return } // ID del abogado seleccionado
        
        db.collection("messages").document(clientId).collection(String(lawyerId))
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error al cargar los mensajes: \(error.localizedDescription)")
                    return
                }
                
                self.messages = snapshot?.documents.compactMap { document in
                    guard let text = document["text"] as? String,
                          let senderId = document["senderId"] as? String else { return nil }
                    return senderId == clientId ? "Tú: \(text)" : "Abogado: \(text)"
                } ?? []
                
                self.tableView.reloadData()
                if !self.messages.isEmpty {
                    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
    }

    
    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCellTableViewCell", for: indexPath) as! MessageCellTableViewCell
        let message = messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }

}
