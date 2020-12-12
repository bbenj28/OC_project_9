//
//  UIViewController+decodeHTML.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 16/11/2020.
//

import Foundation
import UIKit
extension UIViewController {
    /// Decode HTML codes like &#34; to get a String.
    /// - parameter textToDecode: Text received from a HTTP request to decode.
    /// - returns: The decoded text.
    func decodeHTMLCodes(_ textToDecode: String) -> String {
        guard let data = textToDecode.data(using: .utf8) else {
            return textToDecode
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let result = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return textToDecode
        }
        return result.string
    }
}

