//
//  WeatherParser.swift
//  Weather-App
//
//  Created by Георгий Сабанов on 05.07.2021.
//

import Foundation
import SwiftyJSON

enum WeatherParsingError: Error {
    case invalidURL
    case invalidJSON
}

class WeatherParser {
    
    func parseCurrentWeather(json: JSON) throws -> WeatherData {
        guard let temp = json["main"]["temp"].float,
              let pressure = json["main"]["pressure"].float,
              let humidity = json["main"]["humidity"].float,
              let country = json["sys"]["country"].string
        else {
            throw WeatherParsingError.invalidJSON
        }
        return WeatherData(
            temp: temp,
            pressure: pressure,
            humidity: humidity,
            country: country
        )
    }
    
    
    func parseWeekWeather(json: JSON) throws -> WeatherData {
        guard let temp = json["list"][0]["temp"]["day"].float,
              let pressure = json["list"][0]["pressure"].float,
              let humidity = json["list"][0]["humidity"].float,
              let country = json["city"]["country"].string
        else {
            throw WeatherParsingError.invalidJSON
        }
        return WeatherData(
            temp: temp,
            pressure: pressure,
            humidity: humidity,
            country: country)
    }
    
}