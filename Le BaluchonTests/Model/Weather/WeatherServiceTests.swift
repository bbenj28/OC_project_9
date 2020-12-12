//
//  WeatherServiceTests.swift
//  Le BaluchonTests
//
//  Created by Benjamin Breton on 18/11/2020.
//

import XCTest
@testable import Le_Baluchon

class WeatherServiceTests: XCTestCase {

    // MARK: - Network calls
    
    // working
    func testGivenWeatherPageIsSelectedWhenDatasAreAskedThenDatasAreReceived() {
        guard let datas = getDatas(nameNY: "WeatherNY", nameNT: "WeatherNT") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let session = WeatherURLSessionFake(failureInSecondTime: false, datas: datas, response: response, error: nil)
        let service = WeatherService(session: session)
        service.update { (result) in
            switch result {
            case .success(let datas):
                for data in datas {
                    switch data {
                    case .nyWeather(let name):
                        XCTAssert(name == "cloud")
                    case .nyTemperature(let temperature):
                        XCTAssert(temperature == "7")
                    case .niortWeather(let name):
                        XCTAssert(name == "cloud.snow")
                    case .niortTemperature(let temperature):
                        XCTAssert(temperature == "0")
                    }
                }
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
    }
    // wrong response
    func testGivenWeatherPageIsSelectedWhenDatasAreAskedThenAWrongResponseIsReceived() {
        let response = FakeResponseData.responseKO
        let error: Error? = nil
        let session = WeatherURLSessionFake(failureInSecondTime: false, datas: [nil], response: response, error: error)
        let service = WeatherService(session: session)
        service.update { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                print(error.userMessage)
                XCTAssert(error == .ncStatus)
            }
        }
    }
    // no response
    func testGivenWeatherPageIsSelectedWhenDatasAreAskedThenNoResponseIsReceived() {
        let response: HTTPURLResponse? = nil
        let error: Error? = nil
        let session = WeatherURLSessionFake(failureInSecondTime: false, datas: [nil], response: response, error: error)
        let service = WeatherService(session: session)
        service.update { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                guard let error = error as? ApplicationErrors else {
                    XCTFail()
                    return
                }
                print(error.userMessage)
                XCTAssert(error == .ncNoResponse)
            }
        }
    }
    // fake error with NY weather
    func testGivenWeatherPageIsSelectedWhenDatasAreAskedThenAnErrorIsReceived() {
        let error: Error? = FakeResponseData.error
        let session = WeatherURLSessionFake(failureInSecondTime: false, datas: [nil], response: nil, error: error)
        let service = WeatherService(session: session)
        service.update { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                XCTAssert(error is FakeResponseData.FakeError)
            }
        }
    }
    // fake error with NT weather
    func testGivenNYDatasHaveBeenReceivedWhenNTDatasAreAskedThenAnErrorIsReceived() {
        guard let datas = getDatas(nameNY: "WeatherNY", nameNT: "WeatherNT") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let session = WeatherURLSessionFake(failureInSecondTime: true, datas: datas, response: response, error: nil)
        let service = WeatherService(session: session)
        service.update { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                XCTAssert(error is FakeResponseData.FakeError)
            }
        }
    }
    
    // MARK: - Errors when getting datas
    
    // no id
    func testWeatherIdIsMissingWhenWheatherIsAskedThenErrorOccures() {
        guard let datas = getDatas(nameNY: "WeatherNYNoId", nameNT: "WeatherNT") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let session = WeatherURLSessionFake(failureInSecondTime: false, datas: datas, response: response, error: nil)
        let service = WeatherService(session: session)
        service.update { (result) in
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
                XCTAssert(error == .wrId)
            }
        }
    }
    // wrong id so no picture's name
    func testWeatherIdIsWrongWhenWheatherIsAskedThenErrorOccures() {
        guard let datas = getDatas(nameNY: "WeatherNYWrongId", nameNT: "WeatherNT") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let session = WeatherURLSessionFake(failureInSecondTime: false, datas: datas, response: response, error: nil)
        let service = WeatherService(session: session)
        service.update { (result) in
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
                XCTAssert(error == .wrPicture)
            }
        }
    }
    // missing temperature
    func testWeatherTemperatureIsMissingWhenWheatherIsAskedThenErrorOccures() {
        guard let datas = getDatas(nameNY: "WeatherNYNoTemperature", nameNT: "WeatherNT") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let session = WeatherURLSessionFake(failureInSecondTime: false, datas: datas, response: response, error: nil)
        let service = WeatherService(session: session)
        service.update { (result) in
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
                XCTAssert(error == .wrTemp)
            }
        }
    }
    
    // MARK: - Supporting methods
    
    private func getDatas(nameNY: String, nameNT: String) -> [Data]? {
        guard let dataNY = FakeResponseData.getCorrectData(for: nameNY) else {
            return nil
        }
        guard let dataNT = FakeResponseData.getCorrectData(for: nameNT) else {
            return nil
        }
        return [dataNY, dataNT]
    }
    
}
