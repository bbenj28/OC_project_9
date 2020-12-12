//
//  HTTPEngine.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 22/10/2020.
//

import Foundation
typealias HTTPEngineResponse = (Data?, URLResponse?, Error?) -> Void
final class HTTPEngine {
    
    // MARK: - Properties
    
    /// URLSession used for network call.
    private let session: URLSession
    /// URLSessionDataTask used for network call.
    private var task: URLSessionDataTask?
    
    // MARK: - Init
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // MARK: - Response
    
    /// Use to perform a network call and get the response.
    /// - parameter baseUrl: URL to call.
    /// - parameter parameters: Parameters of the call.
    /// - parameter completionHandler: Actions to do with the response.
    func getResponse(baseUrl: URL, parameters: HTTPParameters?, completionHandler: @escaping HTTPEngineResponse) {
        do {
            // get url to call with parameters
            let url = try baseUrl.encode(with: parameters)
            // perform call
            let request = URLRequest(url: url)
            task?.cancel()
            task = session.dataTask(with: request, completionHandler: completionHandler)
            task?.resume()
        } catch {
            // an error occured
            completionHandler(nil, nil, error)
        }
    }
}
