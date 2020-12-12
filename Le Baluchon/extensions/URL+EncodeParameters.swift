//
//  URL+EncodeParameters.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 11/11/2020.
//

import Foundation
extension URL {
    /// Encode the URL with choosen parameters.
    /// - parameter parameters: Parameters to encode URL with.
    /// - returns: The encoded URL.
    func encode(with parameters: HTTPParameters?) throws -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false), let parameters = parameters, !parameters.isEmpty else {
            throw ApplicationErrors.ncUrlEncoding
        }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.0, value: "\($0.1)") }
        guard let url = urlComponents.url else {
            throw ApplicationErrors.ncUrlEncoding
            // changer erreurs
        }
        return url
    }
}
