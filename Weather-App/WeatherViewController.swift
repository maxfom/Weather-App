//
//  WeatherViewController.swift
//  Weather-App
//
//  Created by Максим Фомичев on 01.07.2021.
//

import UIKit

class WeatherViewController: BaseTableViewController {

    // MARK: - Private
    private enum Spec {
        static let newItemAlertTitle = "Add city"
        static let newItemAlertMessage = "Input your city here"
        static let newItemAlertOkButtonTitle = "Save"
        static let newItemAlertCancelButtonTitle = "Cancel"
        static let newItemAlertTextFieldPlaceholder = "ex. Moscow"
    }

    var items: [WeatherListItem] = []

@IBAction func addNewWeatherItem() {
    showAlert(
            title: Spec.newItemAlertTitle,
            message: Spec.newItemAlertMessage,
            cancelButton: Spec.newItemAlertCancelButtonTitle,
            okButton: Spec.newItemAlertOkButtonTitle,
            okAction: { [weak self] itemTitle in
                guard let self = self,
                      let itemTitle = itemTitle
                else {
                    return
                }
                
                self.items.append(WeatherListItem(title: itemTitle))
                self.tableView.reloadData()
            },
            hasTextField: true,
            textFieldPlaceholder: Spec.newItemAlertTextFieldPlaceholder
            )
        }
}

    

// MARK: - UITableViewDelegate, UITableViewDataSource
extension WeatherViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WeatherViewCell.cellIdentifier, for: indexPath) as? WeatherViewCell {
            let item = items[indexPath.row]
            cell.configure(title: item.title)
            return cell
        }
        
        fatalError("Couldn't find cell's class")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        _ = items[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
