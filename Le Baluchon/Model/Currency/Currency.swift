//
//  Currency.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 19/10/2020.
//

import Foundation
/// Currencies used to convert an amount.
enum Currency {
    case euro, dollar
    /// Get currency from its symbol dispatch in the view.
    /// - parameter symbol: The needed currency's symbol.
    /// - returns The needed currency.
    static func getFromSymbol(_ symbol: String) -> Currency? {
        switch symbol {
        case "€":
            return .euro
        case "＄":
            return .dollar
        default:
            return nil
        }
    }
    /// Convert an amount from a currency to the other.
    /// - parameter amount: The amount to convert.
    /// - parameter rate: The rate to apply.
    /// - returns The conversion's result.
    func conversion(amount: Double, rate: Double) -> Double {
        switch self {
        case .dollar:
            return amount / rate
        case .euro:
            return amount * rate
        }
    }
}
