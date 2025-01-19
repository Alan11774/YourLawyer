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
	
	
	let networkMonitor = NetworkReachability.shared

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
			// Verificar conexión a internet
		if !networkMonitor.isConnected {
			Utils.showMessage("No tienes conexión a internet. Verifica tu red.")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		// Verificación del objeto para usarlo de forma asyncronaaa
		guard let lawyer = lawyer else {
			print("Error: Lawyer no inicializado.")
			return
		}
		
		// Configurar Stripe (obtener llaves y configurar PaymentSheet)
		initializeStripe(for: lawyer)
		
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
				self.returnMessage(title: "Pago Exitoso", message: "Gracias por tu compra. Haz contratado a \(self.lawyer?.name ?? "")")

			case .canceled:
				self.returnMessage(title: "Pago Cancelado", message: "Tu pago ha sido cancelado.")
			case .failed(let error):
				self.returnMessage(title: "Error en el pago", message: error.localizedDescription)
			}
		}
	}
	
//	private func navigateToDetailLawyerView() {
		private func navigateToDetailLawyerView() {
			guard let navigationController = self.navigationController else {
				print("Error: No hay un UINavigationController disponible.")
				return
			}

			// Recupera la vista inicial (si deseas mantenerla)
			let allLawyersViewController = navigationController.viewControllers.first(where: { $0 is AllLawyersViewController })

			// Crea la nueva pila con el controlador destino
			var newViewControllers: [UIViewController] = []
			if let allLawyersViewController = allLawyersViewController {
				newViewControllers.append(allLawyersViewController) // Mantén AllLawyersViewController
			}
			let detailViewController = DetailLawyerViewController()
			detailViewController.lawyer = lawyer
			newViewControllers.append(detailViewController)

			// Reemplaza la pila de vistas
			navigationController.setViewControllers(newViewControllers, animated: true)
		}
//	}
	
	private func fetchHourlyRateLawyer(_ lawyer:Lawyer, completion: @escaping (Bool) -> Void){
		DispatchQueue.global().async{
			let isValid = lawyer.hourlyRate > 0
			DispatchQueue.main.async{
				completion(isValid)
			}
		}
	}
	
	//******************************************************************************
	// Llaves ty monto a pagar por abogado.
	//******************************************************************************
	private func fetchStripeKeys(for lawyer:Lawyer ,completion: @escaping (Bool) -> Void) {
		let hourlyRate = lawyer.hourlyRate
		guard  hourlyRate > 0 else {
			print("Error: hourlyRate no está disponible o es inválido.")
			completion(false)
			return
		}
		
		// Convertir hourlyRate a centavos (Stripe usa la menor unidad de la moneda)
		let amountInCents = Int(hourlyRate * 100) // Convertir Double a Int para evitar decimales
		let amountString = "\(amountInCents)"
		
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
				
				createPaymentIntent(amount: amountString, currency: "mxn") { result in
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
	
	//******************************************************************************
	// Usa Completion Handlers para el setup de las keys
	// Para opbjetivos del diplomado , las llaves se extraen de un mismo usuario.
	//******************************************************************************
	
	private func initializeStripe(for lawyer: Lawyer) {
		fetchStripeKeys(for: lawyer) { success in
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
	
	private func returnMessage(title:String,message:String){
		let alertController = UIAlertController(title: title, message: message,preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "Ok", style: .default){_ in
			self.dismiss(animated: true)
		}
		alertController.addAction(alertAction)
		self.present(alertController,animated: true, completion:nil)
	}
}
