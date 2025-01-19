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
//	
//	func fetchCase(email: String, caseId: String, completion: @escaping (Result<Case, Error>) -> Void) {
//			let caseDocRef = db.collection("users")
//				.document(email)
//				.collection("cases")
//				.document(caseId)
//			
//			caseDocRef.getDocument { (document, error) in
//				if let error = error {
//					completion(.failure(error))
//					return
//				}
//
//				guard let document = document, document.exists, let data = document.data() else {
//					let error = NSError(domain: "UserProfileService", code: 404, userInfo: [NSLocalizedDescriptionKey: "El caso no existe en la base de datos."])
//					completion(.failure(error))
//					return
//				}
//				
//				// Parseamos los datos del caso
//				let fetchedCase = Case(
//					caseId: caseId,
//					budget: data["budget"] as? String ?? "",
//					proposedBudget: data["proposedBudget"] as? String ?? "",
//					title: data["title"] as? String ?? "",
//					description: data["caseDescription"] as? String ?? "",
//					requirements: data["requirements"] as? [String] ?? [],
//					tags: data["tags"] as? [String] ?? [],
//					status: data["status"] as? String ?? "",
//					postedBy: data["clientEmail"] as? String ?? "",
//					lawyerEmail: data["lawyerEmail"] as? String ?? ""
//				)
//				
//				completion(.success(fetchedCase))
//			}
//		}
//		
//		// Método para publicar o actualizar un caso en Firestore
//		func postCase(email: String, caseData: Case, completion: @escaping (Result<String, Error>) -> Void) {
//			let updatedData: [String: Any?] = [
//				"caseId": caseData.caseId,
//				"budget": caseData.budget,
//				"proposedBudget": caseData.proposedBudget,
//				"title": caseData.title,
//				"caseDescription": caseData.description,
//				"requirements": caseData.requirements,
//				"tags": caseData.tags,
//				"status": caseData.status,
//				"clientEmail": caseData.postedBy,
//				"lawyerEmail": caseData.lawyerEmail
//			].compactMapValues { $0 }
//			
//			let caseDocRef = db.collection("users")
//				.document(email)
//				.collection("cases")
//				.document(caseData.caseId)
//			
//			caseDocRef.getDocument { (document, error) in
//				if let error = error {
//					completion(.failure(error))
//					return
//				}
//				
//				if let document = document, document.exists {
//					// Si el documento ya existe, actualiza los datos
//					caseDocRef.updateData(updatedData as [AnyHashable : Any]) { error in
//						if let error = error {
//							completion(.failure(error))
//						} else {
//							completion(.success("Caso actualizado exitosamente"))
//						}
//					}
//				} else {
//					// Si el documento no existe, crea uno nuevo
//					caseDocRef.setData(updatedData as [String : Any]) { error in
//						if let error = error {
//							completion(.failure(error))
//						} else {
//							completion(.success("Caso creado exitosamente"))
//						}
//					}
//				}
//			}
//		}
	
}
