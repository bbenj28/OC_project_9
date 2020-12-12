//
//  TranslateJSONStructure.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 22/10/2020.
//

import Foundation
// Structure of the translation's JSON file of google.
struct TranslateJSONStructure {
    let data: TranslateDataJSONStructure?
}
extension TranslateJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
struct TranslateDataJSONStructure {
    let translations: [TranslatedTextJSONStructure]?
}
extension TranslateDataJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case translations = "translations"
    }
}
struct TranslatedTextJSONStructure {
    let translatedText: String?
}
extension TranslatedTextJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case translatedText = "translatedText"
    }
}

