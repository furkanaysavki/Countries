//
//  HomeViewController.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 8.04.2022.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    private var countryArray : [Country] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CustomTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        getData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

         func getData() {
            NetworkManager.instance.fetch(HTTPMethod.get, url: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries" , requestModel: nil, model: CountriesModel.self  ) { response in
                  
                  switch(response)
                  {
                      case .success(let model):
                          let countryModel = model as! CountriesModel
                      print("JSON RESPONSE MODEL : \(String(describing: countryModel.self))")
                      self.countryArray = countryModel.data
                      DispatchQueue.main.async {
                          self.tableView.reloadData()
                      }
                      case .failure(_): break
                  }
                  
              }
        }
            
    func numberOfSections(in tableView: UITableView) -> Int {
        countryArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.countryName.text = countryArray[indexPath.row].name
        cell.configureCountryComponents(model: countryArray[indexPath.section])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailsVC.instantiate()
        detailVC.countryID = countryArray[indexPath.section].code
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
