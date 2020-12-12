//
//  Settings.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 20/10/2020.
//

import Foundation
final class Settings {
    
    // MARK: - Properties
    
    let locale: Locale
    let language: String
    let region: String
    
    // MARK: - Init
    
    init() {
        if let firstLanguage = Locale.preferredLanguages.first, let language = Locale.components(fromIdentifier: firstLanguage)[NSLocale.Key.languageCode.rawValue] {
            self.language = language
        } else {
            self.language = "fr"
        }
        if let region = Locale.current.regionCode {
            self.region = region
        } else {
            self.region = "FR"
        }
        locale = Locale(identifier: "\(self.language)-\(self.region)")
    }
    
    // MARK: - Save and load
    
    /// Save a data of type T in UserDefaults.
    /// - parameter key: The key to use for saving the data.
    /// - parameter data: The data to save.
    func save<T>(key: String, data: T) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    /// Load a data of type T from UserDefaults.
    /// - parameter key: The key used for saving the data.
    /// - parameter defaultValue: Value to return if the data is missing.
    /// - returns: A value of type T.
    func load<T>(key: String, defaultValue: T) -> T {
        if let result = UserDefaults.standard.object(forKey: key) as? T {
            return result
        }
        return defaultValue
    }
}
