//
//  WeatherData.swift
//  Weather-App
//
//  Created by Георгий Сабанов on 02.07.2021.
//

import Foundation
import RealmSwift

class WeatherData: Object {

    @objc dynamic var temp: Float = 0
    @objc dynamic var pressure: Float = 0
    @objc dynamic var humidity: Float = 0
    @objc dynamic var country: String = ""
    
    convenience init(
        temp: Float,
        pressure: Float,
        humidity: Float,
        country: String
    )
    {
        self.init()
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.country = country
    }
    
}
