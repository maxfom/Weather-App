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
}
