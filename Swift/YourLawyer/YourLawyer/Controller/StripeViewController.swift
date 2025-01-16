//
//  StripeViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 14/01/25.
//
import UIKit
import StripePaymentSheet
import Stripe

class StripeViewController: UIViewController {
	var lawyer: Lawyer?
	
	private var paymentSheet: PaymentSheet?
	private var ephemeralKeySecret: String = ""
	private var stripeClientSecret: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		// Configurar Stripe (obtener llaves y configurar PaymentSheet)
		initializeStripe()
		
		// Botón para realizar el pago
		let payButton = UIButton(type: .system)
		payButton.setTitle("Pagar", for: .normal)
		payButton.addTarget(self, action: #selector(presentPaymentSheet), for: .touchUpInside)
		payButton.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(payButton)
		
		NSLayoutConstraint.activate([
			payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			payButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}
	
	private func stripeDefault() {
		// Inicializar la configuración de Stripe
		STPAPIClient.shared.publishableKey = stripeKey
		
		// Configurar PaymentSheet
		var configuration = PaymentSheet.Configuration()
		configuration.merchantDisplayName = appName
		configuration.customer = .init(id: customerID, ephemeralKeySecret: ephemeralKeySecret)
		configuration.applePay = .init(merchantId: "lawyer ID", merchantCountryCode: "US")
		configuration.allowsDelayedPaymentMethods = true
		
		// Crear la PaymentSheet
		paymentSheet = PaymentSheet(paymentIntentClientSecret: stripeClientSecret, configuration: configuration)
	}
	
	@objc private func presentPaymentSheet() {
		// Mostrar la PaymentSheet
		paymentSheet?.present(from: self) { paymentResult in
			switch paymentResult {
			case .completed:
				Utils.showMessage("Gracias por tu compra.")
				self.navigateToDetailLawyerView()
			case .canceled:
				Utils.showMessage("Tu pago ha sido cancelado.")
			case .failed(let error):
				Utils.showMessage(error.localizedDescription)
			}
		}
	}
	
	private func navigateToDetailLawyerView() {
		// Navegar a otra vista después del pago exitoso
		let detailViewController = DetailLawyerViewController() // Reemplaza con tu controlador de detalle
		navigationController?.pushViewController(detailViewController, animated: true)
	}
	
	private func fetchStripeKeys(completion: @escaping (Bool) -> Void) {
		// Obtener la llave ephemeral
		createEphemeralKey(for: customerID) { result in
			switch result {
			case .success(let data):
				if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				   let ephemeralKey = json["secret"] as? String {
					self.ephemeralKeySecret = ephemeralKey
				} else {
					completion(false)
					return
				}
				
				createPaymentIntent(amount: "2000", currency: "mxn") { result in
					switch result {
					case .success(let data):
						if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
						   let clientSecret = json["client_secret"] as? String {
							self.stripeClientSecret = clientSecret
							completion(true) // Llaves obtenidas correctamente
						} else {
							completion(false)
						}
					case .failure:
						completion(false)
					}
				}
			case .failure:
				completion(false)
			}
		}
	}
	
	private func initializeStripe() {
		fetchStripeKeys { success in
			guard success else {
				print("Error al obtener las llaves")
				return
			}
			
			// Ejecutar stripeDefault solo si las llaves se obtuvieron correctamente
			DispatchQueue.main.async {
				self.stripeDefault()
			}
		}
	}
}
