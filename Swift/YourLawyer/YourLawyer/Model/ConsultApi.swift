//
//  ConsultApi.swift
//  YourLawyer
//
//  Created by Alan Ulises on 22/12/24.
//

import Foundation

    // Service
class LawyersService {
      static let shared = LawyersService()
      private init() {}

      func fetchLawyers(completion: @escaping (Result<[Lawyer], Error>) -> Void) {
        guard let url = URL(string: lawyersApiUrl) else {
          completion(.failure(NSError(domain: "URL inválida", code: -1, userInfo: nil)))
          return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
          if let error = error {
            completion(.failure(error))
            return
          }

          guard let data = data else {
            completion(.failure(NSError(domain: "Sin datos", code: -1, userInfo: nil)))
            return
          }

          do {
            let lawyersResponse = try JSONDecoder().decode(LawyersResponse.self, from: data)
              completion(.success(lawyersResponse.lawyers))
          } catch {
            completion(.failure(error))
          }
        }.resume()
      }
    }



	// Service
class CasesService {
      static let shared = CasesService()
      private init() {}

      func fetchCases(completion: @escaping (Result<[Case], Error>) -> Void) {
        guard let url = URL(string: casesApiUrl) else {
          completion(.failure(NSError(domain: "URL inválida", code: -1, userInfo: nil)))
          return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
          if let error = error {
            completion(.failure(error))
            return
          }

          guard let data = data else {
            completion(.failure(NSError(domain: "Sin datos", code: -1, userInfo: nil)))
            return
          }

          do {
            let casesResponse = try JSONDecoder().decode(CasesResponse.self, from: data)
			  completion(.success(casesResponse.cases))
          } catch {
            completion(.failure(error))
          }
        }.resume()
      }
    }


