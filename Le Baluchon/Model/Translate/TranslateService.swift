//
//  Translate.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 22/10/2020.
//

import Foundation
final class TranslateService {
    
    // MARK: - Properties
    
    private let service: HTTPClient
    
    // MARK: - Init
    
    init(session: URLSession = URLSession(configuration: .default)) {
        service = HTTPClient(session: session)
    }
    
    // MARK: - Service
    
    /// Made the network's call and returns the result.
    /// - parameter textToTranslate: The text to be translated.
    /// - parameter language: The language in which the text has to be translated.
    /// - parameter completionHandler: Actions to do with the call's result.
    func getTranslation(textsToTranslate: [String], language: TranslationLanguage, completionHandler: @escaping ((Result<[String], Error>) -> Void)) {
        // get the language's code
        let code = language.googleCode
        // do the network call
        doNetworkCall(texts: textsToTranslate, languageCode: code) { (result) in
            switch result {
            case .success(let data):
                // get the datas
                guard let data = data.data, let translations = data.translations else {
                    completionHandler(.failure(ApplicationErrors.trGoogleError))
                    return
                }
                // put the results in an array
                var texts: [String] = []
                for translation in translations {
                    guard let text = translation.translatedText else {
                        completionHandler(.failure(ApplicationErrors.trGoogleError))
                        return
                    }
                    texts.append(text)
                }
                // transmit the result with the completion handler
                completionHandler(.success(texts))
            case .failure(let error):
                completionHandler(.failure(error))
                return
            }
        }
    }
    
    /// Does the network's call.
    /// - parameter text: The text to be translated.
    /// - parameter languageCode: The google's code for the language in which the text has to be translated.
    /// - parameter completionHandler: Actions to do with the call's result.
    private func doNetworkCall(texts: [String], languageCode: String, completionHandler: @escaping ((Result<TranslateJSONStructure, Error>) -> Void)) {
        var parameters: HTTPParameters = [
            ("key", APIKeys.translateAPIKey),
            ("target", languageCode)
        ]
        for text in texts {
            parameters.append(("q", text))
        }
        service.getData(baseUrl: "https://translation.googleapis.com/language/translate/v2", parameters: parameters, completionHandler: completionHandler)
    }
}
