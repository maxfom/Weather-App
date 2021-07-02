//
//  CitiesViewController.swift
//  Weather-App
//
//  Created by Максим Фомичев on 01.07.2021.
//

import UIKit

class CitiesViewController: BaseTableViewController {

    // MARK: - Private
    private enum Spec {
        enum NewItemAlert {
            static let title = "Add city"
            static let message = "Input your city here"
            enum CancelButton {
                static let title = "Cancel"
            }
            enum OkButton {
                static let title = "Save"
            }
            enum TextField {
                static let placeholder = "ex. Moscow"
            }
        }
    }

    var items: [CityItem] = []

    @IBAction func addNewWeatherItem() {
        showAlert(
            title: Spec.NewItemAlert.title,
            message: Spec.NewItemAlert.message,
            cancelButton: Spec.NewItemAlert.CancelButton.title,
            okButton: Spec.NewItemAlert.OkButton.title,
            okAction: { [weak self] itemTitle in
                guard let self = self,
                      let itemTitle = itemTitle
                else {
                    return
                }
                
                self.items.append(CityItem(title: itemTitle))
                self.tableView.reloadData()
            },
            hasTextField: true,
            textFieldPlaceholder: Spec.NewItemAlert.TextField.placeholder
        )
    }
}

    

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CitiesViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.cellIdentifier, for: indexPath) as? CityTableViewCell {
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
