//
//  TranslationLanguage.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 22/10/2020.
//

import Foundation
enum TranslationLanguage {
    case french, english
    /// Google's code for the choosen language.
    var googleCode: String {
        switch self {
        case .french:
            return "fr"
        case .english:
            return "en"
        }
    }
    /// Code used to hear the translated text.
    var speechCode: String {
        switch self {
        case .french:
            return "fr-FR"
        case .english:
            return "en-US"
        }
    }
}
