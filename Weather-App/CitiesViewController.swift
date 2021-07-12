//
//  CitiesViewController.swift
//  Weather-App
//
//  Created by Максим Фомичев on 01.07.2021.
//

import UIKit
import RealmSwift

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
    
    var items: Results<CityItem> = RealmService.getCities()
    private var token: NotificationToken?
    private let weatherService = WeatherService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        token = items.observe(
            on: .main,
            { [weak self] changes in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    // Query results have changed, so apply them to the UITableView
                    tableView.performBatchUpdates({
                        // Always apply updates in the following order: deletions, insertions, then modifications.
                        // Handling insertions before deletions may result in unexpected behavior.
                        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                             with: .automatic)
                        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                    }, completion: { finished in
                        // ...
                    })
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(error)")
                }
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.invalidate()
    }
    
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
                self.getCity(city: itemTitle) { city in
                    guard let city = city else { return }
                    RealmService.saveCity(city: city)
                }
            },
            hasTextField: true,
            textFieldPlaceholder: Spec.NewItemAlert.TextField.placeholder
        )
    }
    
    func getCity(city: String, completion: @escaping (CityItem?) -> Void) {
        weatherService.getCity(city: city) { [weak self] result in
           switch result {
           case .success(let city):
               completion(city)
               
           case .failure(let error):
               completion(nil)
               self?.showAlert(title: "Error", message: error.localizedDescription, cancelButton: "OK")
           }
       }
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
        let city = items[indexPath.row].title
        guard let vc = storyboard?.instantiateViewController(identifier: "WeatherViewController") as? WeatherViewController else { return }
        vc.configure(city: city)
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            RealmService.removeCity(items[indexPath.row])
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
