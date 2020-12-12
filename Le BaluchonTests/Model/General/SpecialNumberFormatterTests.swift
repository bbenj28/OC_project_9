//
//  SpecialNumberFormatterTests.swift
//  Le BaluchonTests
//
//  Created by Benjamin Breton on 18/11/2020.
//

import XCTest
@testable import Le_Baluchon

class SpecialNumberFormatterTests: XCTestCase {

    // MARK: - Errors
    
    func testGivenANumberInAWrongFormatIsEnteredWhenAsksToFormatItThenReturnsNil() {
        let formatter = SpecialNumberFormatter(.currency)
        let number: Bool = true
        let result: String? = formatter.getFormattedNumber(number)
        XCTAssertNil(result)
    }
}
