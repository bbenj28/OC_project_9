//
//  WeatherResultStructure.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 20/10/2020.
//

import Foundation
// Structure of the JSON file
struct WeatherJSONStructure {
    let weather: [WeatherStructure?]
    let main: MainStructure?
}
extension WeatherJSONStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case main = "main"
    }
}
struct WeatherStructure {
    let id: Int?
}
extension WeatherStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}
struct MainStructure {
    let temp: Float?
}
extension MainStructure: Decodable {
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
    }
}
