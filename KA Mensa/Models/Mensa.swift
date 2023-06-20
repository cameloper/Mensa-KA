//
//  Mensa.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 19.06.23.
//

import Foundation

enum Mensa: String {
    case adenauerring = "mensa_adenauerring"
    case gottesaue = "mensa_gottesaue"
    
    var name: String {
        switch self {
        case .adenauerring:
            return "Mensa am Adenauerring"
        case .gottesaue:
            return "Menseria Schloss Gottesaue"
        }
    }
    
    var index: Int {
        switch self {
        case .adenauerring:
            return 0
        case .gottesaue:
            return 1
        }
    }
    
    static var all: [Mensa] {
        return [.adenauerring, .gottesaue]
    }
}
