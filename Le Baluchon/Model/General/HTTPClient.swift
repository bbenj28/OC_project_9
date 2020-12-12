//
//  HTTPClient.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 22/10/2020.
//

import Foundation
typealias HTTPParameters = [(String, Any)]
final class HTTPClient {
    
    // MARK: - Properties
    
    /// Instantiation of HTTPEngine used to perform network calls.
    private let httpEngine: HTTPEngine
    
    // MARK: - Init
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.httpEngine = HTTPEngine(session: session)
    }
    
    // MARK: - Get datas
    
    /// Ask a network call, analyze received datas to return a property of type T or an error.
    /// - parameter baseUrl: URL to call.
    /// - parameter parameters: Parameters of the call.
    /// - parameter completionHandler: Actions to do with the datas.
    func getData<T: Decodable>(baseUrl: String, parameters: HTTPParameters, completionHandler: @escaping ((Result<T, Error>) -> Void)) {
        // get url from string
        guard let url = URL(string: baseUrl) else {
            completionHandler(.failure(ApplicationErrors.ncUrl))
            return
        }
        // ask for a network call
        httpEngine.getResponse(baseUrl: url, parameters: parameters, completionHandler: {
            (data, response, error) in
            // check the response gets no errors
            guard error == nil else {
                guard let error = error else { return }
                completionHandler(.failure(error))
                return
            }
            // check if a response exists
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(ApplicationErrors.ncNoResponse))
                return
            }
            // check the response's status
            guard response.statusCode == 200 else {
                print("Getted status code : \(response.statusCode)")
                completionHandler(.failure(ApplicationErrors.ncStatus))
                return
            }
            // check data exists
            guard let data = data else {
                completionHandler(.failure(ApplicationErrors.ncNoData))
                return
            }
            // check data is T
            guard let dataJson = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(ApplicationErrors.ncJson))
                return
            }
            // return data
            completionHandler(.success(dataJson))
        })
    }
}
