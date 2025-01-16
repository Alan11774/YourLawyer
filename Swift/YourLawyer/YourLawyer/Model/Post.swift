//
//  Post.swift
//  YourLawyer
//
//  Created by Alan Ulises on 15/01/25.
//

import Foundation

func performPostRequest(
	urlString: String,
	headers: [String: String],
	bodyParameters: [String: Any],
	completion: @escaping (Result<Data, Error>) -> Void
) {
	// Configurar la URL
	guard let url = URL(string: urlString) else {
		print("URL no válida")
		return
	}
	
	// Configurar el cuerpo de la solicitud
	var bodyComponents = URLComponents()
	bodyComponents.queryItems = bodyParameters.map { key, value in
		URLQueryItem(name: key, value: "\(value)")
	}
	
	// Configurar la solicitud
	var request = URLRequest(url: url)
	request.httpMethod = "POST"
	request.httpBody = bodyComponents.query?.data(using: .utf8)
	
	// Agregar encabezados
	for (key, value) in headers {
		request.setValue(value, forHTTPHeaderField: key)
	}
	
	// Crear la tarea de red
	let task = URLSession.shared.dataTask(with: request) { data, response, error in
		if let error = error {
			completion(.failure(error))
			return
		}
		
		guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
			let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
			let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Solicitud fallida con código de estado: \(statusCode)"])
			completion(.failure(error))
			return
		}
		
		if let data = data {
			completion(.success(data))
		}
	}
	
	task.resume()
}

func createEphemeralKey(for customerID: String, completion: @escaping (Result<Data, Error>) -> Void) {
	let url = ephemeralURL
	let headers = [
		"Content-Type": "application/x-www-form-urlencoded",
		"Stripe-Version": "2022-11-15",
		"Authorization": "Basic \(stripeKeySecret.data(using: .utf8)!.base64EncodedString())"
	]
	let body = [
		"customer": customerID
	]
	
	performPostRequest(urlString: url, headers: headers, bodyParameters: body, completion: completion)
}

func createPaymentIntent(amount: String, currency: String, completion: @escaping (Result<Data, Error>) -> Void) {
	let url = clientSecretURL
	let headers = [
		"Content-Type": "application/x-www-form-urlencoded",
		"Authorization": "Basic \(stripeKeySecret.data(using: .utf8)!.base64EncodedString())"
	]
	let body = [
		"amount": amount,
		"currency": currency,
		"automatic_payment_methods[enabled]": "true"
	]
	
	performPostRequest(urlString: url, headers: headers, bodyParameters: body, completion: completion)
}
