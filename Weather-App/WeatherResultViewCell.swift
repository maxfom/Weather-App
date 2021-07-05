//
//  WeatherResultViewCell.swift
//  Weather-App
//
//  Created by Максим Фомичев on 05.07.2021.
//

import UIKit

class WeatherResultViewCell: UITableViewCell {
 
    @IBOutlet weak var weatherLabel: UILabel!
    
    // MARK: - Private
    private enum Spec {

    }

    func configure(title: String) {
        weatherLabel.text = title
    }
    
}

extension WeatherResultViewCell {
    
    static var cellIdentifier: String {
        return "WeatherResultViewCell"
    }
    
}
