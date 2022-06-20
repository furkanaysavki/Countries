//
//  HomeViewController.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 8.04.2022.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    var countryArray = [Datum]()
    var chosenName = ""
    var chosenCode = ""

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        
        getData()
        
    }

    
            
            
        func getData() {
            NetworkManager.instance.fetch(HTTPMethod.get, url: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries" , requestModel: nil, model: Model.self  ) { response in
                  
                  switch(response)
                  {
                      case .success(let model):
                          let countryModel = model as! Model
                          print("JSON RESPONSE MODEL : \(String(describing: countryModel))")
                      self.countryArray = countryModel.data
                      
                      
                      DispatchQueue.main.async {
                          self.tableView.reloadData()
                      }
                      
                                          
                                      
                      case .failure(_): break
                  }
                  
              }
        }
            


    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HomeCell
        cell.countryName.text = countryArray[indexPath.row].name
        cell.codeLabel.text = countryArray[indexPath.row].code
        cell.countryView.layer.cornerRadius = cell.countryView.frame.height / 2
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        chosenName = countryArray[indexPath.row].name
        chosenCode = countryArray[indexPath.row].code
          
           performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
           
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toDetailsVC" {
               let destinationVC = segue.destination as! DetailsVC
               destinationVC.selectedCode = chosenCode
               
           }

}
}
