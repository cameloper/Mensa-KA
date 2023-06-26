//
//  Tag.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation
import UIKit

enum Tag: String, Codable {
    enum Category {
        case additive
        case allergen
        case optional
    }
    
    case colorant = "1"
    case preservant = "2"
    case antioxidant = "3"
    case flavorEnhancer = "4"
    case phosphate = "5"
    case surfaceWaxed = "6"
    case sulphur = "7"
    case blackenedOlives = "8"
    case sweetener = "9"
    case potLaxative = "10"
    case phenylalanine = "11"
    case potAlcohol = "12"
    case assembledMeat = "14"
    case cacaoGlazing = "15"
    case assembledFish = "27"
    
    case beef = "rindfleisch"
    case organicBeef = "regionales-rindfleisch"
    case pork = "schweinefleisch"
    case organicPork = "regionales-schweinefleisch"
    case vegetarian = "vegetarisches-gericht"
    case vegan = "veganes-gericht"
    case msc = "msc"
    case mensaVital = "mensavital"
    case animalRennet = "LAB"
    case gelatine = "GEL"
    
    case cashews = "Ca"
    case speltAndSpeltGluten = "Di"
    case eggs = "Ei"
    case peanuts = "Er"
    case fish = "Fi"
    case barleyAndBarleyGluten = "Ge"
    case oatAndOatGluten = "Hf"
    case hazelnuts = "Ha"
    case kamutAndKamutGluten = "Ka"
    case crustaceans = "Kr"
    case lupin = "Lu"
    case almonds = "Ma"
    case lactose = "ML"
    case brazilianNuts = "Pa"
    case pecans = "Pe"
    case pistachios = "Pi"
    case macadamiaNuts = "Qu"
    case ryeAndRyeGluten = "Ro"
    case sesame = "Sa"
    case celery = "Se"
    case sulphite = "Sf"
    case mustard = "Sn"
    case soya = "So"
    case walnuts = "Wa"
    case wheatAndWheatGluten = "We"
    case molluscs = "Wt"
    
    var category: Category {
        switch self {
        case .colorant,
                .preservant,
                .antioxidant,
                .flavorEnhancer,
                .phosphate,
                .surfaceWaxed,
                .sulphur,
                .blackenedOlives,
                .sweetener,
                .potLaxative,
                .phenylalanine,
                .potAlcohol,
                .assembledMeat,
                .cacaoGlazing,
                .assembledFish:
            return .additive
        case .beef,
                .organicBeef,
                .pork,
                .organicPork,
                .vegetarian,
                .vegan,
                .msc,
                .mensaVital,
                .animalRennet,
                .gelatine:
            return .optional
        case .cashews,
                .speltAndSpeltGluten,
                .eggs,
                .peanuts,
                .fish,
                .barleyAndBarleyGluten,
                .oatAndOatGluten,
                .hazelnuts,
                .kamutAndKamutGluten,
                .crustaceans,
                .lupin,
                .almonds,
                .lactose,
                .brazilianNuts,
                .pecans,
                .pistachios,
                .macadamiaNuts,
                .ryeAndRyeGluten,
                .sesame,
                .celery,
                .sulphite,
                .mustard,
                .soya,
                .walnuts,
                .wheatAndWheatGluten,
                .molluscs:
            return .allergen
        }
    }
    
    var description: String {
        let descriptions: [Tag: String] = [
            // Allergens
            .cashews: "Cashewnüsse",
            .speltAndSpeltGluten: "Dinkel und Gluten aus Dinkel",
            .eggs: "Eier",
            .peanuts: "Erdnüsse",
            .fish: "Fisch",
            .barleyAndBarleyGluten: "Gerste und Gluten aus Gerste",
            .oatAndOatGluten: "Hafer und Gluten aus Hafer",
            .hazelnuts: "Hazelnüsse",
            .kamutAndKamutGluten: "Kamut und Gluten aus Kamut",
            .crustaceans: "Krebstiere",
            .lupin: "Lupine",
            .almonds: "Mandeln",
            .lactose: "Milch / Laktose",
            .brazilianNuts: "Paranüsse",
            .pecans: "Pekannüsse",
            .pistachios: "Pistazie",
            .macadamiaNuts: "Queenslandnüsse / Macadamianüsse",
            .ryeAndRyeGluten: "Roggen und Gluten aus Roggen",
            .sesame: "Sesam",
            .celery: "Sellerie",
            .sulphite: "Schwefeldioxid / Sulfit",
            .mustard: "Senf",
            .soya: "Soja",
            .walnuts: "Walnüsse",
            .wheatAndWheatGluten: "Weizen und Gluten aus Weizen",
            .molluscs: "Weichtiere",
            // Additives
            .colorant: "mit Farbstoff",
            .preservant: "mit Konservierungsstoff",
            .antioxidant: "mit Antioxidationsmittel",
            .flavorEnhancer: "mit Geschmacksverstärker",
            .phosphate: "mit Phosphat",
            .surfaceWaxed: "Oberfläche gewachst",
            .sulphur: "geschwefelt",
            .blackenedOlives: "Oliven geschwärzt",
            .sweetener: "mit Süßungsmitteln",
            .potLaxative: "kann bei übermäßigem Verzehr abführend wirken",
            .phenylalanine: "enthält eine Phenylalaninquelle",
            .potAlcohol: "kann Restalkohol enthalten",
            .assembledMeat: "aus Fleischstücken zusammengefügt",
            .cacaoGlazing: "mit kakaohaltiger Fettglausur",
            .assembledFish: "aus Fischstücken zusammengefügt",
            // Optional indications
            .beef: "enthält Rindfleisch",
            .organicBeef: "enthält regionales Rindfleisch aus artgerechter Tierhaltung",
            .pork: "enthält Schweinefleisch",
            .organicPork: "enthält regionales Schweinefleisch aus artgerechter Tierhaltung",
            .vegetarian: "vegetarisches Gericht",
            .vegan: "veganes Gericht",
            .msc: "MSC aus zertifizierter Fischerei",
            .mensaVital: "MensaVital",
            .animalRennet: "mit tierischem Lab",
            .gelatine: "mit Gelatine"
        ]
        
        return descriptions[self] ?? self.rawValue
    }
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }

}
