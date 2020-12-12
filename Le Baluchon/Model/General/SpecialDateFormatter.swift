//
//  SpecialDateFormatter.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 19/11/2020.
//

import Foundation
final class SpecialDateFormatter {
    
    // MARK: - Properties
    
    /// General settings and savings of the application.
    private let settings = Settings()
    
    // MARK: - Get date
    
    /// Generate a formatted date from a date.
    /// - parameter date: The date to be formatted.
    /// - returns: The formatted date.
    func getFormattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = settings.locale
        return formatter.string(from: date)
    }
}
