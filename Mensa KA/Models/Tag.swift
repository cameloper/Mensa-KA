//
//  Tag.swift
//  MensaKA
//
//  Created by Yilmaz, Ihsan on 20.06.23.
//

import Foundation

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
    case cocoaGlaze = "15"
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
    case nuts = "Pa"
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
                .cocoaGlaze,
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
                .nuts,
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

}
