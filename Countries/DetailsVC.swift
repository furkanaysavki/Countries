//
//  DetailsVC.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 11.04.2022.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData



class DetailsVC: UIViewController {
    
    
    var selectedCode = ""
    var selectedUrl = ""
    var vikiData  = ""
    
    @IBOutlet weak var flagImage: UIImageView!
    
    
    @IBOutlet weak var countryCode: UILabel!
    
   
    @IBOutlet weak var nameLabel: UILabel!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.async {
            
        self.countryCode.text = "Country Code : \(self.selectedCode)"
        
        }
        
       
        
        getImage()
        
        
        }
    override func viewWillAppear(_ animated: Bool) {
        getDetails()
    }
    
    func getDetails() {
        
            NetworkManager.instance.fetch(HTTPMethod.get, url: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/\(selectedCode)" , requestModel: nil, model: DetailsModel.self  ) { response in
              
              switch(response)
              {
                  case .success(let model):
                  
                      let detailsModel = model as! DetailsModel
                    print("JSON RESPONSE MODEL : \(String(describing: detailsModel))")
                  
                  
                 self.nameLabel.text = String(detailsModel.data.name)
                 self.selectedUrl = String(detailsModel.data.flagImageURI)
                 self.vikiData = String(detailsModel.data.wikiDataID)
                  
                 
                  
                  
                                  
                  case .failure(_): break
              }
                
            }
        
            
    }
    
    
    func getImage(){
       
            
        
        AF.request( "selectedUrl", method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
                self.flagImage.image = UIImage(data: responseData!, scale:1)

            case .failure(let error):
                print("error--->",error)
           
            }
        }
    }
    
 
    @IBAction func informationButton(_ sender: Any) {
        if let url = URL(string: "https://www.wikidata.org/wiki/\(self.vikiData)") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
       
        
    }
    }
    
    @IBAction func favouriteClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newCountry = NSEntityDescription.insertNewObject(forEntityName: "Countries", into: context)
        newCountry.setValue(nameLabel.text!, forKey: "name")
        newCountry.setValue("selectedCode.self", forKey: "code")
        
       
        do{
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        
    }
    }



    
        

        

        
        
    
    
    
   

