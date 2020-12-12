//
//  TranslateDelegate.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 10/11/2020.
//

import Foundation
final class CurrencyService {
    
    // MARK: - Properties
    
    /// Instantiation of the service used to do network calls.
    private let service: HTTPClient
    
    // MARK: - Init
    
    init(session: URLSession = URLSession(configuration: .default)) {
        service = HTTPClient(session: session)
    }
    
    // MARK: - Getting rate

    /// Ask a network call to get a new rate.
    /// - parameter completionHandler: Actions to do with the call's result.
    func getRate(completionHandler: @escaping ((Result<Double, Error>) -> Void)) {
        doNetworkCall { (result) in
            switch result {
            case.success(let data):
                guard let rate = data.rates.usd else {
                    completionHandler(.failure(ApplicationErrors.cyWrongData))
                    return
                }
                completionHandler(.success(rate))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    /// Perform a network call.
    /// - parameter completionHandler: Actions to do with the call's result.
    private func doNetworkCall(completionHandler: @escaping ((Result<CurrencyJSONStructure, Error>) -> Void)) {
        let parameters: HTTPParameters = [
            ("access_key", APIKeys.currencyAPIKey),
            ("symbols", "USD")
        ]
        service.getData(baseUrl: "http://data.fixer.io/api/latest", parameters: parameters, completionHandler: completionHandler)
    }
}



