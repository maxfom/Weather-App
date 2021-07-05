//
//  WeatherData.swift
//  Weather-App
//
//  Created by Георгий Сабанов on 02.07.2021.
//

import Foundation

struct WeatherData {

    let temp: Float
    let pressure: Float
    let humidity: Float
    let country: String
    
    init(
        temp: Float,
        pressure: Float,
        humidity: Float,
        country: String
         )
    {
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.country = country
    }
    
}
