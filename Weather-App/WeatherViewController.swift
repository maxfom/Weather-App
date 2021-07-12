//
//  WeatherViewController.swift
//  Weather-App
//
//  Created by Георгий Сабанов on 02.07.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift

class WeatherViewController: BaseTableViewController {

    private var city: String = ""
    private var weathers: List<WeatherData>?
    private var token: NotificationToken?
    
    private let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        weathers = RealmService.getWeathers(for: city)
//        let cities = RealmService.getCities()
//        let citiesReference = ThreadSafeReference(to: cities)
//        DispatchQueue.main.async {
//            let realm = try? Realm()
//            let unwrappedCities = realm?.resolve(citiesReference)
//            print(unwrappedCities?.first?.title ?? "")
//        }

        getWeather(city: city) { [weak self] weather in
            guard let self = self, let weather = weather else { return }
            RealmService.saveWeather([weather], to: self.city)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        token = weathers?.observe(
            on: .main,
            { [weak self] _ in
                self?.tableView.reloadData()
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.invalidate()
    }
    
    func configure(city: String) {
        self.city = city
    }
    
    enum WeatherParsingError: Error {
        case invalidURL
    }
    
    func getWeather(city: String, completion: @escaping (WeatherData?) -> Void) {
        weatherService.getWeather(city: city) { [weak self] result in
           switch result {
           case .success(let weather):
               completion(weather)
               
           case .failure(let error):
               completion(nil)
               self?.showAlert(title: "Error", message: error.localizedDescription, cancelButton: "OK")
           }
       }
    }
    
}

extension WeatherViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weathers?.first == nil {
            return 0
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weather = weathers?.first else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: WeatherResultViewCell.cellIdentifier, for: indexPath) as? WeatherResultViewCell {
                switch indexPath.row {
                case 0:
                    cell.configure(title: "Температура: \(weather.temp) ºC")
                    
                case 1:
                    cell.configure(title: "Давление: \(weather.pressure)")

                case 2:
                    cell.configure(title: "Влажность: \(weather.humidity)")

                case 3:
                    cell.configure(title: "Страна: \(weather.country)")
                    
                default:
                    break
                }
                return cell
            }
        }
        
        fatalError("Couldn't find cell's class")
    }
}
