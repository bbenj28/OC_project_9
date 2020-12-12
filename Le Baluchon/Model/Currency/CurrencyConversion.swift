//
//  CurrencyConversion.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 19/10/2020.
//

import Foundation
/// Class used to convert an amount from a currency to the other by getting rate and applying it.
final class CurrencyConversion {
    
    // MARK: - Properties
    
    /// General settings and savings of the application.
    private let settings = Settings()
    /// Rate used for conversion.
    private lazy var rate: Double = settings.load(key: "rate", defaultValue: 0)
    /// Rate's last updating date.
    private lazy var dateRate: Date = settings.load(key: "rateUpdatingDate", defaultValue: Date() - 60 * 60 * 24)
    /// Formatted rate's last updating date.
    private(set) var formattedDate: String?
    /// Formatted rate
    private(set) var formattedRate: String?
    /// Service used to perform networks calls.
    private let service: CurrencyService
    
    // MARK: - Init
    
    init(session: URLSession = URLSession(configuration: .default)) {
        service = CurrencyService(session: session)
    }

    // MARK: - Getting rate
    
    /// Check if a network call has to be done to get a new rate, and, eventually, call it.
    /// - parameter updateForcing: has the update to be forced even if a rate has already been saved and loaded ?
    /// - parameter completionHandler: Actions to do with the result.
    func updateRateAndGetInformations(updateForcing: Bool, completionHandler: @escaping ((Result<String, Error>) -> Void)) {
        // checks if a rate has been saved the last 24 hours and eventually loads it
        if updateForcing || dateRate <= Date() - 60 * 60 * 24 || rate == 0{
            // gets a new rate
            service.getRate { (result) in
                switch result {
                case .success(let rate):
                    self.rate = rate
                    self.settings.save(key: "rate", data: rate)
                    let date = Date()
                    self.dateRate = date
                    self.settings.save(key: "rateUpdatingDate", data: date)
                    self.getInformations { (result) in
                        switch result {
                        case .success(let informations):
                            completionHandler(.success(informations))
                        }
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } else {
            self.getInformations { (result) in
                switch result {
                case .success(let informations):
                    completionHandler(.success(informations))
                }
            }
        }
    }
    /// Get informations about the rate and its upload.
    /// - returns: Informations to display.
    private func getInformations(completionHandler: @escaping (Result<String, Never>) -> Void) {
        let dateFormatter = SpecialDateFormatter()
        let formattedDate = dateFormatter.getFormattedDate(dateRate)
        self.formattedDate = formattedDate
        let rateFormatter = RateNumberFormatter()
        guard let formattedRate: String = rateFormatter.getFormattedNumber(rate) else { return }
        self.formattedRate = formattedRate
        completionHandler(.success("taux EUR -> USD : \(formattedRate)\nobtenu le \(formattedDate)"))
    }

    // MARK: - Conversion
    
    /// Convert an amount from a currency to the other.
    /// - parameter amount: The amount to convert.
    /// - parameter startCurrency: The entered amount's currency's symbol.
    func convert(amount: String, from startCurrencySymbol: String, completionHandler: @escaping (Result<[String], Error>) -> Void) {
        let formatter: CurrencyNumberFormatter
        if let amount = Double(amount), amount > 99999999999 {
            formatter = CurrencyNumberFormatter(isLong: true)
        } else {
            formatter = CurrencyNumberFormatter(isLong: false)
        }
        
        guard let doubleAmount: Double = formatter.getFormattedNumber(amount), doubleAmount > 0 else {
            completionHandler(.failure(ApplicationErrors.cyWrongAmountFormat))
            return
        }
        guard let startCurrency = Currency.getFromSymbol(startCurrencySymbol) else {
            completionHandler(.failure(ApplicationErrors.cyWrongCurrencySymbol))
            return
        }
        let result = startCurrency.conversion(amount: doubleAmount, rate: rate)
        guard let resultText: String = formatter.getFormattedNumber(result) else { return }
        guard let fieldText: String = formatter.getFormattedNumber(doubleAmount) else { return }
        completionHandler(.success([fieldText, resultText]))
    }
}



