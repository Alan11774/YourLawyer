//
//  Projects.swift
//  YourLawyer
//
//  Created by Alan Ulises on 21/12/24.
//

import Foundation

struct LawyersResponse: Decodable {
    let lawyers: [Lawyer]
}

struct Lawyer: Decodable {
    let id: Int
    let name: String
    let description: String
    let imageURL: String?
    let projectsWorkedOn: Int
    let rating: Double
    let numberOfHirings: Int
    let profileViews: Int
    let userDescription: String
    let skills: [String]
    let hourlyRate: Double
}

class LawyerManager {
    static let shared = LawyerManager()
    
    var selectedLawyer: Lawyer?
    
    private init() {} // Una sola instancia 
}
