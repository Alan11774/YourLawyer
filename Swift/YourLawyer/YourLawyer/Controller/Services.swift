//
//  Services.swift
//  Barman
//
//  Created by Ángel González on 06/12/24.
//

import Foundation
import CryptoKit

class Services {
    
    func encriptarPassword(_ pass:String) -> String   {
        var newPass = ""
        let salt = ""
        guard let bytes = (pass + salt).data(using: .utf8) else { return "" }
        let hashPass = SHA256.hash(data: bytes)
        newPass = hashPass.compactMap { String(format: "%02x", $0) }.joined()
        return newPass
    }
}
