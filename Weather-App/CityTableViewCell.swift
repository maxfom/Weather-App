//
//  CityTableViewCell.swift
//  Weather-App
//
//  Created by Максим Фомичев on 01.07.2021.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Private
    private enum Spec {

    }

    func configure(title: String) {
        titleLabel.text = title
    }
    
}

extension CityTableViewCell {
    
    static var cellIdentifier: String {
        return "CityTableViewCell"
    }
    
}
