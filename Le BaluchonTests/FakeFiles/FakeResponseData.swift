//
//  FakeResponseData.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 17/11/2020.
//

import Foundation
class FakeResponseData {
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    class FakeError: Error {}
    static let error = FakeError()
    static func getCorrectData(for resourceName: String) -> Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    static let incorrectData = "erreur".data(using: .utf8)!
}
