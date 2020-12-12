//
//  HTTPClientTests.swift
//  Le BaluchonTests
//
//  Created by Benjamin Breton on 18/11/2020.
//

import XCTest
@testable import Le_Baluchon

class HTTPClientTests: XCTestCase {

    // MARK: - Errors
    
    func testGivenURLStringIsEmptyWhenCreatesURLThenErrorOccuresInHTTPClient() {
        let data: Data? = nil
        let response: HTTPURLResponse? = nil
        let error: Error? = FakeResponseData.error
        let session = URLSessionFake(data: data, response: response, error: error)
        let client = HTTPClient(session: session)
        client.getData(baseUrl: "", parameters: []) { (result: Result<CurrencyJSONStructure, Error>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                print(error)
                print(error.userMessage)
                XCTAssert(error == .ncUrl)
            }
        }
    }
    func testGivenResponseIsNilWhenUnwrappingItThenErrorOccuresInHTTPClient() {
        let data: Data? = nil
        let response: HTTPURLResponse? = nil
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let client = HTTPClient(session: session)
        let parameters: HTTPParameters = [("q","r")]
        client.getData(baseUrl: "http://www.openclassrooms.com", parameters: parameters) { (result: Result<CurrencyJSONStructure, Error>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                print(error)
                print(error.userMessage)
                XCTAssert(error == .ncNoResponse)
            }
        }
    }
    func testGivenDataIsNilWhenUnwrappingItThenErrorOccuresInHTTPClient() {
        let data: Data? = nil
        let response: HTTPURLResponse? = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let client = HTTPClient(session: session)
        let parameters: HTTPParameters = [("q","r")]
        client.getData(baseUrl: "http://www.openclassrooms.com", parameters: parameters) { (result: Result<CurrencyJSONStructure, Error>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                print(error)
                print(error.userMessage)
                XCTAssert(error == .ncNoData)
            }
        }
    }
    func testGivenDatasAreCurrencyDatasWhenDatasAreAnalyzedToBeWeatherDatasThenErrorOccuresInHTTPClient() {
        guard let data = FakeResponseData.getCorrectData(for: "Currency") else {
            XCTFail()
            return
        }
        let response: HTTPURLResponse? = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let client = HTTPClient(session: session)
        let parameters: HTTPParameters = [("q","r")]
        client.getData(baseUrl: "http://www.openclassrooms.com", parameters: parameters) { (result: Result<WeatherJSONStructure, Error>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                print(error)
                print(error.userMessage)
                XCTAssert(error == .ncJson)
            }
        }
    }
}
