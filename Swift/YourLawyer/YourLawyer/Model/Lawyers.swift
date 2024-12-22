//
//  Projects.swift
//  YourLawyer
//
//  Created by Alan Ulises on 21/12/24.
//

import Foundation

struct LawyersResponse: Decodable {
  let abogados: [Lawyer]
}

struct Lawyer: Decodable {
  let id: Int
  let name: String
  let description: String
  let imageURL: String?
}
