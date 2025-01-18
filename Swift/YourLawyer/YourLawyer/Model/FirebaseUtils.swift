//
//  Firebase.swift
//  YourLawyer
//
//  Created by Alan Ulises on 17/01/25.
//

import Foundation
import FirebaseFirestore


class UserProfileService {
	
	
	// Singleton para acceder desde cualquier lugar/
	static let shared = UserProfileService()
	private init() {}
	
	let db = Firestore.firestore()
	func fetchUserProfile(email: String, completion: @escaping (Result<Profile, Error>) -> Void) {
		
		
		db.collection("users")
			.document(email)
			.collection("profile")
			.document("userInformation")
			.getDocument { (document, error) in
				if let error = error {
					completion(.failure(error))
					return
				}

				guard let document = document, document.exists, let data = document.data() else {
					let error = NSError(domain: "UserProfileService", code: 404, userInfo: [NSLocalizedDescriptionKey: "El perfil no existe en la base de datos."])
					completion(.failure(error))
					return
				}

				// Parseamos los datos del perfil
				let userProfile = Profile(
					email: email,
					name: data["name"] as? String ?? "",
					lastName: data["lastName"] as? String ?? "",
					userRole: data["userRole"] as? String ?? "",
					imageURL: data["imageURL"] as? String ?? "",
					userDescription: data["userDescription"] as? String ?? "",
					skills: data["skills"] as? [String] ?? [""],
					language: data["language"] as? [String] ?? [""],
					hourlyRate: data["hourlyRate"] as? String ?? ""
				)

				completion(.success(userProfile))
			}
	}
	
	
	
}
