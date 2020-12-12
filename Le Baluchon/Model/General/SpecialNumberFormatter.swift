//
//  NumberFormat.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 23/10/2020.
//

import Foundation

// MARK: - SpecialNumberFormatter

class SpecialNumberFormatter {
    
    // MARK: - Properties
    
    /// The numbertype for the formatter : temperature or currency.
    private var numberType: NumberTypes
    
    // MARK: - Init
    
    init(_ numberType: NumberTypes) {
        self.numberType = numberType
    }
    
    // MARK: - Get number
    
    /// Convert a number of an entry type in a formatted number of an exit type.
    /// - parameter number: The number to convert.
    /// - returns: The formatted number.
    func getFormattedNumber<EntryType, ExitType>(_ number: EntryType) -> ExitType? {
        guard let amount = number as? String else {
            let type: NumberFormat = .system(numberType)
            if let number = number as? Double, let stringNumber = type.formatter.string(from: NSNumber(value: number)) {
                return decodeAndReturnU(stringNumber)
            }
            if let number = number as? Float, let stringNumber = type.formatter.string(from: NSNumber(value: number)) {
                return decodeAndReturnU(stringNumber)
            }
            return nil
        }
        let stringNumber = amount.replacingOccurrences(of: ",", with: ".")
        return decodeAndReturnU(stringNumber)
    }
    /// Decode the meaning of the exit type and return the value.
    /// - parameter number: The number to return.
    /// - returns : The formatted number in the exit type.
    private func decodeAndReturnU<ExitType>(_ number: String) -> ExitType? {
        var type: NumberFormat = .system(numberType)
        guard let number = type.formatter.number(from: number) else {
            return nil
        }
        var result: ExitType? = nil
        if result is String? {
            type = .locale(numberType)
            result = type.formatter.string(from: number) as? ExitType
        }
        if result is Double? {
            result = Double(truncating: number) as? ExitType
        }
        return result
    }
}

// MARK: Currency/Weather Formatters

/// SpecialNumberFormatter for the currency model to display an amount.
class CurrencyNumberFormatter: SpecialNumberFormatter {
    init(isLong: Bool) {
        if isLong {
            super.init(.scientificCurrency)
        } else {
            super.init(.currency)
        }
    }
}
/// SpecialNumberFormatter for the currency model to display the rate.
class RateNumberFormatter: SpecialNumberFormatter {
    init() { super.init(.rate) }
}
/// SpecialNumberFormatter for the weather model.
class WeatherNumberFormatter: SpecialNumberFormatter {
    init() { super.init(.temperature) }
}

// MARK: - NumberFormat

/// Used to get the formatter regarding the needed format : system or locale.
private enum NumberFormat {
    case system(NumberTypes)
    case locale(NumberTypes)
    /// The numberformatter linked to the CurrencyNumberFormat.
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        let settings = Settings()
        switch self {
        case .locale(.scientificCurrency), .system(.scientificCurrency):
            formatter.numberStyle = .scientific
            formatter.maximumFractionDigits = 6
        case .locale(.currency), .system(.currency):
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
        case .locale(.temperature), .system(.temperature):
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
        default:
            formatter.maximumFractionDigits = 10
            formatter.minimumFractionDigits = 0
        }
        switch self {
        case .locale(_):
            formatter.decimalSeparator = settings.locale.decimalSeparator
        case .system(_):
            formatter.decimalSeparator = "."
        }
        return formatter
    }
}

// MARK: - NumberTypes

/// Types of number : currency or temperature.
enum NumberTypes {
    case temperature, currency, rate, scientificCurrency
}
