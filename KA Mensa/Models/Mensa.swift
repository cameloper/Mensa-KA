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
    case moltke = "mensa_moltke"
    case moltkestrasse = "mensa_x1moltkestrasse"
    case erzberger = "mensa_erzberger"
    case tiefenbronner = "mensa_tiefenbronner"
    case holzgarten = "mensa_holzgarten"
    
    var name: String {
        switch self {
        case .adenauerring:
            return "Mensa am Adenauerring"
        case .gottesaue:
            return "Menseria Schloss Gottesaue"
        case .moltke:
            return "Mensa Moltke"
        case .moltkestrasse:
            return "Menseria Moltkestraße 30"
        case .erzberger:
            return "Menseria Erzbergerstraße"
        case .tiefenbronner:
            return "Mensa Tiefenbronnerstraße"
        case .holzgarten:
            return "Menseria Holzgartenstraße"
        }
    }
    
    var shortName: String {
        return name.split(separator: " ").dropFirst().joined(separator: " ")
    }
    
    var index: Int {
        return Mensa.all.firstIndex(of: self) ?? 0
    }
    
    static var all: [Mensa] {
        return [.adenauerring, .gottesaue, .moltke, .moltkestrasse, .erzberger, .tiefenbronner, .holzgarten]
    }
}
