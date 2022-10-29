//
//  SavedViewController.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 10.04.2022.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {

    
    private var countries: [Countries] = [] {
        didSet {
            tableView.reloadData()
        }
    }
       
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMoviesFromPersistance()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: FavouriteTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FavouriteTableViewCell.identifier)
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
}
    extension FavouriteViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.rowHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spaceView = UIView()
        spaceView.backgroundColor = view.backgroundColor
        return spaceView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constant.headerHeightInSection
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier, for: indexPath) as? FavouriteTableViewCell else {
            return UITableViewCell()
        }
        cell.countryID = countries[indexPath.section].code ??  ""
        cell.configureCountryComponents(model: Country(code: countries[indexPath.section].code ?? "", name: countries[indexPath.section].name ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailsVC.instantiate()
        detailVC.countryID = countries[indexPath.section].code ?? ""
       
        navigationController?.pushViewController(detailVC, animated: true)
    }
    }

