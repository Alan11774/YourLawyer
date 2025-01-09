//
//  Case.swift
//  YourLawyer
//
//  Created by Alan Ulises on 08/01/25.
//

import Foundation

struct Case: Codable {
    let caseId: String
    let imageURL: String
    let title: String
    let description: String
    let category: String
    let postedBy: String
    let postedDate: String
    let budget: String
    let location: String
    let status: String
    let details: CaseDetails
}

struct CaseDetails: Codable {
    let tags: [String]
    let requirements: [String]
    let urgency: String
}
