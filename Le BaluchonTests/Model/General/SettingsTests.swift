//
//  SettingsTests.swift
//  Le BaluchonTests
//
//  Created by Benjamin Breton on 18/11/2020.
//

import XCTest
@testable import Le_Baluchon

class SettingsTests: XCTestCase {

    // MARK: - Using default value
    
    func testGivenAWrongKeyIsEnteredWhenAsksToLoadItThenReturnsDefaultValue() {
        let settings = Settings()
        let number: Int = settings.load(key: "wrongKey", defaultValue: 1515)
        XCTAssert(number == 1515)
    }
}
