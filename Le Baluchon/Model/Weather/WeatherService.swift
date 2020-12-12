//
//  WeatherUpdate.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 20/10/2020.
//

import Foundation
final class WeatherService {
    
    // MARK: - Properties
    
    /// Service used to perform network calls.
    private let service: HTTPClient
    
    // MARK: - Init
    
    init(session: URLSession = URLSession(configuration: .default)) {
        service = HTTPClient(session: session)
    }
    
    // MARK: - Updating
    
    /// Ask for getting weather data and for displaying it.
    /// - parameter completionHandler: Actions to do with the result.
    func update(completionHandler: @escaping (Result<[WeatherResult], Error>) -> Void) {
        doNetworkCall(cityName: "New York") { (result) in
            switch result {
            case .success(let nyData):
                self.doNetworkCall(cityName: "Niort") { (result) in
                    switch result {
                    case .success(let niortData):
                        self.sortDatas(niortData: niortData, nyData: nyData, completionHandler: completionHandler)
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    /// Perform a network call to get weather datas of a city.
    /// - parameter cityName: The cityname.
    /// - parameter completionHandler : Actions to do with the result.
    private func doNetworkCall(cityName: String, completionHandler: @escaping ((Result<WeatherJSONStructure, Error>) -> Void)) {
        let parameters: HTTPParameters = [
            ("q", cityName),
            ("appid", APIKeys.weatherAPIKey),
            ("units", "metric")
        ]
        service.getData(baseUrl: "http://api.openweathermap.org/data/2.5/weather", parameters: parameters, completionHandler: completionHandler)
    }
    
    /// Sort datas to get the needed informations.
    /// - parameter dataNiort: Data for Niort.
    /// - parameter dataNY: Data for New York.
    private func sortDatas(niortData: WeatherJSONStructure, nyData: WeatherJSONStructure, completionHandler: (Result<[WeatherResult], Error>) -> Void) {
        // pictures ids
        guard let niortId = niortData.weather[0]?.id, let nyId = nyData.weather[0]?.id else {
            completionHandler(.failure(ApplicationErrors.wrId))
            return
        }
        // pictures names
        guard let niortPicture = WeatherCodes.getWeatherFromCode(niortId)?.pictureName, let nyPicture = WeatherCodes.getWeatherFromCode(nyId)?.pictureName else {
            completionHandler(.failure(ApplicationErrors.wrPicture))
            return
        }
        // temperatures
        let formatter = WeatherNumberFormatter()
        guard let niortDataTemp = niortData.main?.temp, let niortTemp: String = formatter.getFormattedNumber(niortDataTemp), let nyDataTemp = nyData.main?.temp, let nyTemp: String = formatter.getFormattedNumber(nyDataTemp) else {
            completionHandler(.failure(ApplicationErrors.wrTemp))
            return
        }
        // success
        completionHandler(.success([WeatherResult.niortTemperature(niortTemp), WeatherResult.nyTemperature(nyTemp), WeatherResult.niortWeather(niortPicture), WeatherResult.nyWeather(nyPicture)]))
    }

}
