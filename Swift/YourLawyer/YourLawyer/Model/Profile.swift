//
//  Profile.swift
//  YourLawyer
//
//  Created by Alan Ulises on 02/01/25.
//

import Foundation


struct Profile: Codable {
    let email: String
    let name: String
    let lastName :String
    let userRole: String
    let imageURL: String?
    let userDescription: String
    let skills: [String]
    let language : [String]
    let hourlyRate: String
}


class ProfileManager {
	static let shared = ProfileManager()
	
	var signedInProfile: Profile?
	
	private init() {} // Una sola instancia
}
