//
//  CurrencyResultStructure.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 20/10/2020.
//

import Foundation
// Structure of the fixer's JSON file
struct CurrencyJSONStructure {
    let rates: RatesStructure
}
extension CurrencyJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case rates = "rates"
    }
}
struct RatesStructure {
    let usd: Double?
}
extension RatesStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}
