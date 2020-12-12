//
//  TranslateServiceTests.swift
//  Le BaluchonTests
//
//  Created by Benjamin Breton on 18/11/2020.
//

import XCTest
@testable import Le_Baluchon

class TranslateServiceTests: XCTestCase {

    // MARK: - Network calls (
    
    // working
    func testGivenTranslatePageIsSelectedWhenANewTranslationIsAskedThenTranslationIsReceived() {
        guard let data = FakeResponseData.getCorrectData(for: "Translate") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = TranslateService(session: session)
        guard let language = getLanguage("🇺🇸") else {
            XCTFail()
            return
        }
        service.getTranslation(textsToTranslate: ["Bonjour monsieur le président", "Je vais me promener"], language: language) { (result) in
            switch result {
            case .success(let translation):
                XCTAssert(translation == ["Good morning Mister President", "I will go for a walk"])
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
    }
    // working with reverse language
    func testGivenTranslatePageIsSelectedWhenANewTranslationWithOtherLanguageIsAskedThenTranslationIsReceived() {
        guard let data = FakeResponseData.getCorrectData(for: "TranslateReverse") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = TranslateService(session: session)
        guard let language = getLanguage("🇫🇷") else {
            XCTFail()
            return
        }
        service.getTranslation(textsToTranslate: ["Good morning Mister President", "I will go for a walk"], language: language) { (result) in
            switch result {
            case .success(let translation):
                XCTAssert(translation == ["Bonjour monsieur le président", "Je vais me promener"])
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
    }
    // wrong response
    func testGivenTranslatePageIsSelectedWhenANewTranslationIsAskedThenAWrongResponseIsReceived() {
        let data: Data? = nil
        let response = FakeResponseData.responseKO
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = TranslateService(session: session)
        guard let language = getLanguage("🇺🇸") else {
            XCTFail()
            return
        }
        service.getTranslation(textsToTranslate: ["Bonjour monsieur le président", "Je vais me promener"], language: language, completionHandler: { (result) in
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
        })
    }
    // wrong response
    func testGivenTranslatePageIsSelectedWhenANewTranslationIsAskedThenNoResponseIsReceived() {
        let data: Data? = nil
        let response: HTTPURLResponse? = nil
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = TranslateService(session: session)
        guard let language = getLanguage("🇺🇸") else {
            XCTFail()
            return
        }
        service.getTranslation(textsToTranslate: ["Bonjour monsieur le président", "Je vais me promener"], language: language, completionHandler: { (result) in
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
        })
    }
    // fake error
    func testGivenTranslatePageIsSelectedWhenANewTranslationIsAskedThenAnErrorIsReceived() {
        let data: Data? = nil
        let response: HTTPURLResponse? = nil
        let error: Error? = FakeResponseData.error
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = TranslateService(session: session)
        guard let language = getLanguage("🇺🇸") else {
            XCTFail()
            return
        }
        service.getTranslation(textsToTranslate: ["Bonjour monsieur le président", "Je vais me promener"], language: language, completionHandler: { (result) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                print(error.userMessage)
                XCTAssert(error is FakeResponseData.FakeError)
            }
        })
    }
    
    // MARK: - Flag errors
    
    // no flag
    func testGivenNoFlagHasBeenSelectedWhenAskForTranslationLanguageThenAnErrorOccures() {
        let language = getLanguage(nil)
        let error = ApplicationErrors.trNoLanguage
        print(error)
        print(error.userMessage)
        XCTAssertNil(language)
    }
    // no working flag
    func testGivenAnUnknownedFlagHasBeenSelectedWhenAskForTranslationLanguageThenAnErrorOccures() {
        let language = getLanguage("🇩🇪")
        let error = ApplicationErrors.trNoLanguage
        print(error)
        print(error.userMessage)
        XCTAssertNil(language)
    }
    
    // MARK: - Errors when sorting datas
    
    // no translations
    func testGivenDatasHaveNoTranslationsWhenSortingItThenAnErrorOccures() {
        guard let data = FakeResponseData.getCorrectData(for: "TranslateMissingTranslations") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = TranslateService(session: session)
        guard let language = getLanguage("🇺🇸") else {
            XCTFail()
            return
        }
        service.getTranslation(textsToTranslate: ["Bonjour monsieur le président", "Je vais me promener"], language: language) { (result) in
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
                XCTAssert(error == .trGoogleError)
            }
        }
    }
    // missing a translated text
    func testGivenDatasHaveATranslatedTextMissingWhenSortingItThenAnErrorOccures() {
        guard let data = FakeResponseData.getCorrectData(for: "TranslateMissingATranslatedText") else {
            XCTFail()
            return
        }
        let response = FakeResponseData.responseOK
        let error: Error? = nil
        let session = URLSessionFake(data: data, response: response, error: error)
        let service = TranslateService(session: session)
        guard let language = getLanguage("🇺🇸") else {
            XCTFail()
            return
        }
        service.getTranslation(textsToTranslate: ["Bonjour monsieur le président", "Je vais me promener"], language: language) { (result) in
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
                XCTAssert(error == .trGoogleError)
            }
        }
    }
    
    // MARK: - Hear translations codes
    
    // american translation
    func testAnAmericanTranslationHasBeenDisplayedWhenAsksToHearItThenTheGoodSpeechCodeIsReturned() {
        guard let language = getLanguage("🇺🇸") else {
            XCTFail()
            return
        }
        let code = language.speechCode
        XCTAssert(code == "en-US")
    }
    // french translation
    func testAFrenchTranslationHasBeenDisplayedWhenAsksToHearItThenTheGoodSpeechCodeIsReturned() {
        guard let language = getLanguage("🇫🇷") else {
            XCTFail()
            return
        }
        let code = language.speechCode
        XCTAssert(code == "fr-FR")
    }
    
    // MARK: - Supporting methods
    
    /// Returns the language of the result flag.
    private func getLanguage(_ flag: String?) -> TranslationLanguage? {
        guard let flag = flag else {
            return nil
        }
        switch flag {
        case "🇺🇸":
            return .english
        case "🇫🇷":
            return .french
        default:
            return nil
        }
    }
}
