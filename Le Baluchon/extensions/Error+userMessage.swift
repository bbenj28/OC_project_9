//
//  Error+userMessage.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 17/11/2020.
//

import Foundation
extension Error {
    /// Message to display to users if an error occured.
    var userMessage: String {
        if let error = self as? ApplicationErrors {
            switch error {
            // network call
            case .ncUrl, .ncJson, .ncStatus, .ncUrlEncoding, .ncNoData, .ncNoResponse:
                return "Une erreur de communication internet a été rencontrée."
            // currency
            case .cyWrongAmountFormat:
                return "Pour qu'une conversion soit effectuée, il convient qu'un nombre correct soit entré dans le champ prévu. Merci de le vérifier."
            case .cyWrongCurrencySymbol:
                return "Une erreur a été rencontrée dans la conversion."
            case .cyWrongData:
                return "Une erreur a été rencontrée dans la récupération du taux sur internet. Merci de réessayer plus tard."
            // weather
            case .wrId, .wrPicture, .wrTemp:
                return "Une erreur a été rencontrée dans la récupération de la météo sur internet. Merci de réessayer plus tard."
            // translate
            case .trNoLanguage, .trGoogleError:
                return "Une erreur a été rencontrée dans la récupération de la traduction sur internet. Merci de réessayer plus tard."
            }
        } else {
            return "Une erreur s'est produite. L'action demandée n'a pas pu être effectuée."
        }
    }
}
