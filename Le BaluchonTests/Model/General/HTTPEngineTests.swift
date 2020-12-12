//
//  HTTPEngineTests.swift
//  Le BaluchonTests
//
//  Created by Benjamin Breton on 18/11/2020.
//

import XCTest
@testable import Le_Baluchon

class HTTPEngineTests: XCTestCase {

    // MARK: - Errors
    
    func testGivenParametersAreEmptyWhenCreatesURLThenErrorOccuresInHTTPEngine() {
        let data: Data? = nil
        let response: HTTPURLResponse? = nil
        let error: Error? = FakeResponseData.error
        let session = URLSessionFake(data: data, response: response, error: error)
        let engine = HTTPEngine(session: session)
        guard let url = URL(string: "http://www.moi.fr") else {
            XCTFail()
            return
        }
        engine.getResponse(baseUrl: url, parameters: []) { (data, response, error) in
            guard let error = error as? ApplicationErrors else {
                XCTFail()
                return
            }
            print(error)
            print(error.userMessage)
            XCTAssert(error == .ncUrlEncoding)
        }
    }
}
