//
//  WeatherCodesTests.swift
//  Le BaluchonTests
//
//  Created by Benjamin Breton on 18/11/2020.
//

import XCTest
@testable import Le_Baluchon

class WeatherCodesTests: XCTestCase {

    // MARK: - Network calls
    
    // tests all remaining codes
    func testGivenWeatherPageIsSelectedWhenDatasAreAskedThenDatasAreReceived() {
        let jsonNT = [200, 212, 300, 502, 611, 700, 781, 800]
        let resultNT = ["cloud.bolt.rain", "cloud.bolt", "cloud.drizzle", "cloud.heavyrain", "cloud.sleet", "smoke", "tornado", "sun.max"]
        let jsonNY = [210, 230, 500, 600, 615, 741, 781, 801]
        let resultNY = ["cloud.sun.bolt", "cloud.bolt.rain", "cloud.rain", "snow", "snow", "cloud.fog", "tornado", "cloud.sun"]
        
        for index in 0...7 {
            guard let datas = getDatas(nameNY: "WeatherNY\(jsonNY[index])", nameNT: "WeatherNT\(jsonNT[index])") else {
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
                            XCTAssert(name == resultNY[index])
                        case .niortWeather(let name):
                            XCTAssert(name == resultNT[index])
                        default:
                            break
                        }
                    }
                case .failure(let error):
                    print(error)
                    XCTFail()
                }
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
