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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather(city: city) { weather in
            DispatchQueue.main.async {
                print(weather?.temp)
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
                let weather = WeatherData(temp: json["main"]["temp"].floatValue)
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
