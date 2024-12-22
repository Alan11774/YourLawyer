//
//  Constants.swift
//  Barman
//
//  Created by JanZelaznog on 26/02/23.
//

import Foundation
import UIKit

public let lawyersApiUrl = "https://private-56712-yourlawyer1.apiary-mock.com/lawyers"

class Utils {
    class func showMessage(_ message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)

        // Obtener la escena activa
        guard let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }),
              let rootViewController = keyWindow.rootViewController else {
            print("No se encontró una ventana o un controlador de vista raíz")
            return
        }

        // Presentar el alerta desde el controlador de vista más visible
        DispatchQueue.main.async {
            var topController = rootViewController
            while let presentedController = topController.presentedViewController {
                topController = presentedController
            }
            topController.present(alertController, animated: true)
        }
    }

}

