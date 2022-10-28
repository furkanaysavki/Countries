//
//  SavedViewController.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 10.04.2022.
//

import UIKit
import CoreData

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private var countries: [Countries] = []
       
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMoviesFromPersistance()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CustomTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomTableViewCell.identifier)
        
       
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        fetchMoviesFromPersistance()
    }
    private func fetchMoviesFromPersistance() {
        CoreDataManager.shared.getCountriesFromPersistance { result in
            switch result {
            case .success(let favourite):
                self.countries = favourite
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.countryID = countries[indexPath.section].code!
        cell.configureCountryComponents(model: Country(code: countries[indexPath.row].code!, name: countries[indexPath.row].name!))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailsVC.instantiate()
        detailVC.countryID = countries[indexPath.section].code ?? ""
       
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
