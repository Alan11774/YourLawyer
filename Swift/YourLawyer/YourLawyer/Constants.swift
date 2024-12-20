//
//  Constants.swift
//  Barman
//
//  Created by JanZelaznog on 26/02/23.
//

import Foundation
import UIKit

struct File {
    static let main = (name: "drinks", extension: "json")
}

struct CellID {
    static let drinkID = "TableViewCellDrinkID"
}

struct SegueID {
    static let detail = "detailSegueID"
}

struct Sites {
    static let baseURL = "http://janzelaznog.com/DDAM/iOS/drinksimages/"
}

public let baseUrl = "http://janzelaznog.com/DDAM/iOS"
public let colorPrimaryDark:UInt = 0x9933cc
public let colorAccent:UInt = 0xD9E933
public let regularFont:String = "San Francisco"

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

    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
}

extension UITextField {
    func customize(_ transparent:Bool) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5;
        self.layer.borderColor = Utils.UIColorFromRGB(rgbValue: colorAccent).cgColor
        self.backgroundColor = .white
        self.font = UIFont(name: regularFont, size: 16)
        self.textColor = Utils.UIColorFromRGB(rgbValue: colorPrimaryDark)
        if transparent {
            self.backgroundColor = .clear
            self.layer.borderColor = Utils.UIColorFromRGB(rgbValue: colorPrimaryDark).cgColor
            self.textColor = Utils.UIColorFromRGB(rgbValue: colorAccent)
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}







