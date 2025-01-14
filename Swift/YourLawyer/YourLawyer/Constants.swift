//
//  Constants.swift
//  Barman
//
//  Created by JanZelaznog on 26/02/23.
//

import Foundation
import UIKit
import Kingfisher

//public let lawyersApiUrl = "https://private-56712-yourlawyer1.apiary-mock.com/lawyers"
public let lawyersApiUrl = "https://private-56712-yourlawyer1.apiary-mock.com/all/lawyers"
public let categoryLawyers = ["Selecciona tu categoría", "Derecho Penal", "Derecho Laboral", "Derecho Familiar", "Derecho Administrativo", "Derecho Civil", "Derecho Comercial", "Derecho Constitucional", "Derecho de la Familia", "Derecho de la Justicia", "Derecho de la Constitución"

]
public let requirements = [
    "Presupuesto detallado",
    "Cronograma del caso",
    "Informes periódicos sobre el avance del caso",
    "Acceso a toda la documentación del caso",
    "Explicaciones claras y sencillas sobre el proceso legal",
    "Disponibilidad para responder preguntas",
    "Representación en todas las audiencias",
    "Asesoramiento personalizado",
    "Confidencialidad absoluta",
    "Comunicación efectiva y oportuna",
    "Defensa de mis intereses de manera agresiva",
    "Búsqueda de una solución negociada si es posible",
    "Prioridad en mi caso",
    "Facilidad para contactar al abogado",
    "Flexibilidad en los horarios de atención",
    "Garantía de resultados",
    "Referencias de clientes anteriores"
]

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


struct UIHelpers {
    static func createDropdownFieldWithAlert(options: [String], placeholder: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(placeholder, for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addAction(UIAction(handler: { _ in
            guard let viewController = button.findViewController() else {
                print("No se encontró un ViewController para presentar el UIAlertController")
                return
            }

            let alertController = UIAlertController(title: "Selecciona una opción", message: nil, preferredStyle: .actionSheet)

            for option in options {
                let action = UIAlertAction(title: option, style: .default) { _ in
                    button.setTitle(option, for: .normal)
                    button.setTitleColor(.black, for: .normal)
                }
                alertController.addAction(action)
            }

            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            viewController.present(alertController, animated: true, completion: nil)
        }), for: .touchUpInside)

        return button
    }
}

extension UIView {
    /// Encuentra el ViewController asociado a la vista.
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}


@MainActor func loadImage(uri: Any, imageView: UIImageView, placeholderResId: UIImage? = nil, scaleType: String = "circleCrop") {
    if let url = uri as? URL {
        // Si es una URL, utiliza Kingfisher para cargar la imagen
        var options: KingfisherOptionsInfo = []
        
        switch scaleType {
        case "circleCrop":
            options.append(.processor(RoundCornerImageProcessor(cornerRadius: .greatestFiniteMagnitude)))
        case "centerCrop":
            options.append(.scaleFactor(UIScreen.main.scale))
        default:
            fatalError("Invalid scale type: \(scaleType)")
        }
        
        imageView.kf.setImage(
            with: url,
            placeholder: placeholderResId,
            options: options
        )
    } else if let image = uri as? UIImage {
        // Si es un UIImage, asigna directamente la imagen al UIImageView
        imageView.image = image
        
    } else {
        print("Invalid URI: \(uri)")
    }
}

