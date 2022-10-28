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



final class DetailsVC: UIViewController {
    
    
    var vikiData  = ""
    var countryName = ""
    var countryID = ""
    private var countryDetail: DetailsModel?
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad()  {
        super.viewDidLoad()
       
           getDetails()
        
        }
        
      
    func getDetails()  {
        let group = DispatchGroup()
        group.enter()
        
            NetworkManager.instance.fetch(HTTPMethod.get, url: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/\(countryID)" , requestModel: nil, model: DetailsModel.self  ) { response in
                
                switch(response)
                 {
                  case .success(let model):
                  let detailsModel = model as! DetailsModel
                    print("JSON RESPONSE MODEL : \(String(describing: detailsModel))")
                  
                  self.vikiData = String(detailsModel.data.wikiDataID)
                  self.countryName = String(detailsModel.data.name)
                  self.countryCode.text = String("Country Code : \(detailsModel.data.code)")
                  group.leave()
              
                  case .failure(_): break
                 
              }
                group.enter()
                self.nameLabel.text = "Country Name : \(self.countryName)"
                let coder = SDImageSVGCoder.shared
                SDImageCodersManager.shared.addCoder(coder)
               
                let svgURL = URL(string: "http://commons.wikimedia.org/wiki/Special:FilePath/Flag%20of%20\(self.countryName).svg" )!
                         self.flagImage.sd_setImage(with: svgURL) { (image, error, cacheType, url) in
                             if image != nil {
                                 print("SVGView SVG load success")
                             }
                group.leave()
                }
                }
        }
    
    @IBAction func informationButton(_ sender: Any) {
        if let url = URL(string: "https://www.wikidata.org/wiki/\(self.vikiData)") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    }
    
    @IBAction func favouriteClicked(_ sender: Any) {
        CoreDataManager.shared.checkIsFavourite(with: countryID ) { result in
            switch result {
            case .success(let bool):
                if bool {
                    CoreDataManager.shared.deleteMovie(with: self.countryID) { error in
                        print(error)
                    }
                    self.saveButton.setImage(UIImage(systemName: "star"), for: .normal)
                } else {
                    CoreDataManager.shared.createFavouriteCountry(with: Country(code: (self.countryDetail?.data.code)!, name: (self.countryDetail?.data.name)!))
                    self.saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
