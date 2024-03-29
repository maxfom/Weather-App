//
//  RealmService.swift
//  Weather-App
//
//  Created by Георгий Сабанов on 07.07.2021.
//

import Foundation
import RealmSwift

class RealmService {
    
    static func saveCity(city: CityItem) {
        let realm = try! Realm()
        try? realm.write {
            realm.add(city, update: .all)
        }
    }
    
    static func getCities() -> Results<CityItem> {
        let realm = try! Realm()
        return realm.objects(CityItem.self).sorted(byKeyPath: "title")
    }
    
    static func removeCity(_ city: CityItem) {
        let realm = try! Realm()
        try? realm.write {
            realm.delete(city)
        }
    }
    
    static func saveWeather(_ weather: WeatherData, to city: String) {
        let realm = try! Realm()
        guard let city = realm.object(ofType: CityItem.self, forPrimaryKey: city) else { return }
        try? realm.write {
            city.currentWeather = weather
        }
    }
    
    static func getWeathers(for city: String) -> WeatherData? {
        let realm = try! Realm()
        guard let city = realm.object(ofType: CityItem.self, forPrimaryKey: city) else { return nil }
        return city.currentWeather
    }
    
    static func saveForecast(_ weathers: [WeatherData], to city: String) {
        let realm = try! Realm()
        guard let city = realm.object(ofType: CityItem.self, forPrimaryKey: city) else { return }
        let oldWeather = city.forecast
        try? realm.write {
            realm.delete(oldWeather)
            city.forecast.append(objectsIn: weathers)
        }
    }
    
    static func getForecast(for city: String) -> List<WeatherData>? {
        let realm = try! Realm()
        guard let city = realm.object(ofType: CityItem.self, forPrimaryKey: city) else { return nil }
        return city.forecast
    }
    
}
