//
//  WeatherService.swift
//  Weather-App
//
//  Created by Георгий Сабанов on 05.07.2021.
//

import Foundation
import SwiftyJSON

class WeatherService {
    
    private let networkService = NetworkService()
    
    private enum Spec {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let appId = "1476cbc9d619a63c252081ffbe570446"
        static let units = "metric"
    }
    
    enum Endpoint: String {
        case currentWeather = "/data/2.5/weather"
        case oneCall = "/data/2.5/onecall"
    }
    
    func defaultParameters() -> [String: String] {
        [
            "appid": Spec.appId,
            "units": Spec.units
        ]
    }
    
    @discardableResult
    func sendRequest(endpoint: Endpoint, parameters: [String: String], completion: @escaping (Result<JSON, Error>) -> Void) -> URLSessionDataTask? {
        var components = URLComponents()
        components.scheme = Spec.scheme
        components.host = Spec.host
        components.path = endpoint.rawValue
        let parametersDict = defaultParameters().merging(parameters) { (_, new) in new }
        components.queryItems = parametersDict.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let url = components.url else {
            completion(.failure(WeatherParsingError.invalidURL))
            return nil
        }
        let request = URLRequest(url: url)
        let task = networkService.sendRequest(request: request, completion: completion)
        task.resume()
        return task
    }

    
    @discardableResult
    func getWeather(city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) -> URLSessionDataTask? {
        let task = sendRequest(endpoint: .currentWeather, parameters: ["q": city]) { result in
            switch result {
            case .success(let json):
                do {
                    let weather = try WeatherParser().parseCurrentWeather(json: json)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    @discardableResult
    func getCity(city: String, completion: @escaping (Result<CityItem, Error>) -> Void) -> URLSessionDataTask? {
        let task = sendRequest(endpoint: .currentWeather, parameters: ["q": city]) { result in
            switch result {
            case .success(let json):
                do {
                    let weather = try WeatherParser().parseCityFromCurrentWeather(json: json, city: city)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }

    @discardableResult
    func getWeekForecast(lat: Double, lng: Double, completion: @escaping (Result<[WeatherData], Error>) -> Void) -> URLSessionDataTask? {
        let task = sendRequest(
            endpoint: .oneCall,
            parameters: [
                "lat": "\(lat)",
                "lon": "\(lng)",
                "exclude": "current,minutely,hourly,alerts"
            ]
        ) { result in
            switch result {
            case .success(let json):
                do {
                    let weather = try WeatherParser().parseWeekForecast(json: json)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }

}
