//
//  WeatherViewController.swift
//  Weather-App
//
//  Created by Георгий Сабанов on 02.07.2021.
//

import UIKit
import SwiftyJSON

class WeatherViewController: BaseTableViewController {

    private var city: String = ""
    
    var items: [WeatherData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather(city: city) { weather in
            DispatchQueue.main.async {
                print(weather?.temp)
                print(weather?.pressure)
                print(weather?.humidity)
                print(weather?.country)
            }
        }
    }
    
    func configure(city: String) {
        self.city = city
    }
    
    @discardableResult
    func getWeather(city: String, completion: @escaping (WeatherData?) -> Void) -> URLSessionDataTask {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=1476cbc9d619a63c252081ffbe570446&units=metric")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let json = JSON(data)
                let weather = WeatherData(
                    temp: json["main"]["temp"].floatValue,
                    pressure: json["main"]["pressure"].floatValue,
                    humidity: json["main"]["humidity"].floatValue,
                    country: json["sys"]["country"].string!
                )
                completion(weather)
            } else if let error = error {
                completion(nil)
                print(error.localizedDescription)
            }
        }
        task.resume()
        return task
    }
    
}

extension WeatherViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WeatherResultViewCell.cellIdentifier, for: indexPath) as? WeatherResultViewCell {
            let item = items[indexPath.row]
            cell.configure(title: city)
            return cell
        }
        
        fatalError("Couldn't find cell's class")
    }
}
