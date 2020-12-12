//
//  WeatherCodes.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 21/10/2020.
//

import Foundation
/// Codes used to get a weather picture.
enum WeatherCodes {
    case cloudBoltRain, cloudSunBolt, cloudBolt, cloudDrizzle, cloudRain, cloudHeavyRain, cloudSnow, cloudSleet, smoke, cloudFog, tornado, sunMax, cloudSun, snow, cloud
    /// Name of the picture representing the recorded weather's code.
    var pictureName: String {
        switch self {
        case .cloudBoltRain:
            return "cloud.bolt.rain"
        case .cloudSunBolt:
            return "cloud.sun.bolt"
        case .cloudBolt:
            return "cloud.bolt"
        case .cloudDrizzle:
            return "cloud.drizzle"
        case .cloudRain:
            return "cloud.rain"
        case .cloudHeavyRain:
            return "cloud.heavyrain"
        case .cloudSnow:
            return "cloud.snow"
        case .cloudSleet:
            return "cloud.sleet"
        case .smoke:
            return "smoke"
        case .cloudFog:
            return "cloud.fog"
        case .tornado:
            return "tornado"
        case .sunMax:
            return "sun.max"
        case .cloudSun:
            return "cloud.sun"
        case .snow:
            return "snow"
        case .cloud:
            return "cloud"
        }
    }
    /// Returns the weather's code from its id getted in the JSON datas.
    /// - parameter id: The weather's id.
    /// - returns: The weather's code.
    static func getWeatherFromCode(_ id: Int) -> WeatherCodes? {
        switch id {
        case 200...202:
            return .cloudBoltRain
        case 210...211:
            return .cloudSunBolt
        case 212...221:
            return .cloudBolt
        case 230...299:
            return .cloudBoltRain
        case 300...399:
            return .cloudDrizzle
        case 500...501:
            return .cloudRain
        case 502...504:
            return .cloudHeavyRain
        case 511...599:
            return .cloudSnow
        case 600...602:
            return .snow
        case 611...613:
            return .cloudSleet
        case 615...699:
            return .snow
        case 700...731:
            return .smoke
        case 741...771:
            return .cloudFog
        case 781...799:
            return .tornado
        case 800:
            return .sunMax
        case 801:
            return .cloudSun
        case 802...899:
            return .cloud
        default:
            return nil
        }
    }
}
