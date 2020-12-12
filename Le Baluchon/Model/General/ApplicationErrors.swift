//
//  ApplicationErrors.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 19/10/2020.
//

import Foundation
enum ApplicationErrors: Error, CustomStringConvertible {
    
    // MARK: - Errors
    
    // network call
    case ncNoData, ncNoResponse, ncStatus, ncJson, ncUrl, ncUrlEncoding
    // currency errors
    case cyWrongAmountFormat, cyWrongData, cyWrongCurrencySymbol
    // weather errors
    case wrId, wrPicture, wrTemp
    // translate errors
    case trNoLanguage, trGoogleError
    
    // MARK: - Descriptions
    
    /// Description to print in the console for developpers to know whats is the problem.
    var description: String {
        switch self {
        // network call
        case .ncNoData:
            return "La requête ne retourne aucune donnée. F-HTTPClient."
        case .ncNoResponse:
            return "La requête ne retourne aucune réponse. F-HTTPClient."
        case .ncStatus:
            return "Le code du statut de la requête n'est pas valide. F-HTTPClient."
        case .ncJson:
            return "Les données reçues n'ont pu être converties dans le format JSON correspondant. F-HTTPClient."
        case .ncUrl:
            return "Une erreur concernant l'URL a été rencontrée. F-HTTPClient."
        case .ncUrlEncoding:
            return "Une erreur concernant l'ajout des paramètres de l'URL a été rencontrée. F-URL+EncodeParameters."
        // currency errors
        case .cyWrongAmountFormat:
            return "Le montant indiqué dans le champ texte n'est pas valable. F-CurrencyConversion"
        case .cyWrongCurrencySymbol:
            return "Le symbole utilisé pour la monnaie est inconnu ou inexistant. F-CurrencyConversion"
        case .cyWrongData:
            return "Aucun taux n'a pu être obtenu, erreur liée probablement à la structure JSON. F-CurrencyService."
        // weather errors
        case .wrId:
            return "L'ID correspondant aux conditions météorologiques n'a pas pu être obtenue, erreur liée probablement à la structure JSON. F-WeatherService."
        case .wrPicture:
            return "Les images correspondant aux conditions météorologiques n'ont pu être obtenues, erreur liée au code obtenu et au nom de l'image qui devrait correspondre à ce code. F-WeatherService."
        case .wrTemp:
            return "La température n'a pas pu être obtenue, erreur liée probablement à la structure JSON. F-WeatherService."
        // translate errors
        case .trNoLanguage:
            return "Le language dans lequel le texte doit être traduit n'a pas pu être reconnu à partir du drapeau. F-TranslateService."
        case .trGoogleError:
            return "Le texte traduit n'a pas pu être récupéré, erreur liée probablement à la structure JSON. F-TranslateService."
        }
    }
}
