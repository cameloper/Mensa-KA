//
//  Mensa.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 19.06.23.
//

import Foundation

class Mensa {
    public static let mensa_adenauerring = Mensa(id: "mensa_adenauerring", name: "Mensa am Adenauerring")
    
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
