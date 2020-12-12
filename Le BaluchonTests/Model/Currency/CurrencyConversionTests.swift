//
//  CurrencyConversionTests.swift
//  Le BaluchonTests
//
//  Created by Benjamin Breton on 18/11/2020.
//

import XCTest
@testable import Le_Baluchon

class CurrencyConversionTests: XCTestCase {
    
    // MARK: - Network calls
    // working
    func testGivenApplicationIsLaunchedWhenANewCurrencysRateIsAskedThenARateIsReceived() {
        guard let data = FakeResponseData.getCorrectData(for: "Currency") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(let informations):
                guard let formattedDate = service.formattedDate, let formattedRate = service.formattedRate else {
                    XCTFail()
                    return
                }
                XCTAssert(informations == "taux EUR -> USD : \(formattedRate)\nobtenu le \(formattedDate)")
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
    }
    // wrong response
    func testGivenApplicationIsLaunchedWhenANewCurrencysRateIsAskedThenAWrongResponseIsReceived() {
        let data: Data? = nil
        let response = FakeResponseData.responseKO
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                print(error)
                print(error.userMessage)
                XCTAssert(error == ApplicationErrors.ncStatus)
            }
        }
    }
    // no response
    func testGivenApplicationIsLaunchedWhenANewCurrencysRateIsAskedThenNoResponseIsReceived() {
        let data: Data? = nil
        let response: HTTPURLResponse? = nil
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                print(error)
                print(error.userMessage)
                XCTAssert(error == ApplicationErrors.ncNoResponse)
            }
        }
    }
    // fake error
    func testGivenApplicationIsLaunchedWhenANewCurrencysRateIsAskedThenAnErrorIsReceived() {
        let data: Data? = nil
        let response: HTTPURLResponse? = nil
        let error: Error? = FakeResponseData.error
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                XCTAssert(error is FakeResponseData.FakeError)
            }
        }
    }
    
    // MARK: - Errors when getting data
    
    func testCurrencyRateIsMissingWhenANewCurrencysRateIsAskedThenErrorOccures() {
        guard let data = FakeResponseData.getCorrectData(for: "CurrencyWrongData") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyService(session: session)
        service.getRate { (result) in
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
                XCTAssert(error == .cyWrongData)
            }
        }
    }
    
    // MARK: - Conversion
    
    // working
    func testGivenAnEuroAmountHasBeenEnteredWhenAsksForConversionThenFormattedResultIsReturned() {
        guard let data = FakeResponseData.getCorrectData(for: "Currency") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        service.convert(amount: "909,978654", from: "€") { (result) in
            switch result {
            case .success(let conversion):
                XCTAssert(conversion[0] == "909,98")
                XCTAssert(conversion[1] == "1080,30")
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
    }
    func testGivenADollarAmountHasBeenEnteredWhenAsksForConversionThenFormattedResultIsReturned() {
        guard let data = FakeResponseData.getCorrectData(for: "Currency") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        service.convert(amount: "909,978654", from: "＄") { (result) in
            switch result {
            case .success(let conversion):
                XCTAssert(conversion[0] == "909,98")
                XCTAssert(conversion[1] == "766,51")
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
    }
    func testGivenABigDollarAmountHasBeenEnteredWhenAsksForConversionThenFormattedResultIsReturned() {
        guard let data = FakeResponseData.getCorrectData(for: "Currency") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        service.convert(amount: "1000000000000", from: "＄") { (result) in
            switch result {
            case .success(let conversion):
                XCTAssert(conversion[0] == "1E12")
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
    }
    // amount's error
    func testGivenAWrongAmountHasBeenEnteredWhenAsksForConversionThenErrorOccures() {
        guard let data = FakeResponseData.getCorrectData(for: "Currency") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        service.convert(amount: "909,978,654", from: "€") { (result) in
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
                XCTAssert(error == .cyWrongAmountFormat)
            }
        }
    }
    // currency's symbol error
    func testGivenAWrongCurrencySymbolHasBeenEnteredWhenAsksForConversionThenErrorOccures() {
        guard let data = FakeResponseData.getCorrectData(for: "Currency") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = CurrencyConversion(session: session)
        service.updateRateAndGetInformations(updateForcing: true) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        service.convert(amount: "909,978654", from: "￡") { (result) in
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
                XCTAssert(error == .cyWrongCurrencySymbol)
            }
        }
    }
    
}
