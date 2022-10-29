//
//  HomeViewController.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 8.04.2022.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
   
    private var countryArray : [Country] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HomeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.identifier)
       
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
    
}
  extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
      
     func numberOfSections(in tableView: UITableView) -> Int {
     countryArray.count
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
      guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
          return UITableViewCell()
     }
       cell.countryID = countryArray[indexPath.section].code
       cell.configureCountryComponents(model: countryArray[indexPath.section])
       return cell
     }
      
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let detailVC = DetailsVC.instantiate()
     detailVC.countryID = countryArray[indexPath.section].code
     navigationController?.pushViewController(detailVC, animated: true)
     }
    }
