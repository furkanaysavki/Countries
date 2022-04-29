//
//  DetailsVC.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 11.04.2022.
//

import UIKit
import Alamofire
import CoreData
import SDWebImageSVGCoder



class DetailsVC: UIViewController {
    
    
    var selectedCode = ""
    var vikiData  = ""
    var countryName = ""
    
    @IBOutlet weak var flagImage: UIImageView!
    
    
    @IBOutlet weak var countryCode: UILabel!
    
   
    @IBOutlet weak var nameLabel: UILabel!
    
    
   
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        self.countryCode.text = "Country Code : \(self.selectedCode)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        self.nameLabel.text = "Country Name : \(self.countryName)"
        }
           getDetails()
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        let coder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(coder)
       
        let svgURL = URL(string: "http://commons.wikimedia.org/wiki/Special:FilePath/Flag%20of%20\(self.countryName).svg" )!
                 self.flagImage.sd_setImage(with: svgURL) { (image, error, cacheType, url) in
                     if image != nil {
                         print("SVGView SVG load success")
                     
          
         
       
                     }
                   
                      
                }
        
      
       
        }
        
      
    func getDetails()  {
        
            NetworkManager.instance.fetch(HTTPMethod.get, url: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/\(selectedCode)" , requestModel: nil, model: DetailsModel.self  ) { response in
                
                 
              switch(response)
              {
                  case .success(let model):
                  
                   
                      let detailsModel = model as! DetailsModel
                    print("JSON RESPONSE MODEL : \(String(describing: detailsModel))")
                  
              
                   
                 //self.nameLabel.text = String(detailsModel.data.name)
                 self.vikiData = String(detailsModel.data.wikiDataID)
                  self.countryName = String(detailsModel.data.name)
                 
                  
                  
              
                  case .failure(_): break
                  
              }
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
