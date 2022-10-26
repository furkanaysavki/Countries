//
//  CustomTableViewCell.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 25.10.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    static let identifier = String(describing: CustomTableViewCell.self)
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var countryID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
    }

    @objc func saveButtonClicked() {
        
        CoreDataManager.shared.checkIsFavourite(with: countryID ) { result in
            switch result {
            case .success(let bool):
                if bool {
                    CoreDataManager.shared.deleteMovie(with: self.countryID) { error in
                        print(error)
                    }
                    self.saveButton.setImage(UIImage(systemName: "star"), for: .normal)
                } else {
                    CoreDataManager.shared.createFavouriteCountry(with: Country(code: self.countryID, name: self.countryName.text!))
                    self.saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
            case .failure(let error):
                print(error)
            }
        }
    
}
    func configureCountryComponents(model: Country) {
        countryName.text = model.name
        CoreDataManager.shared.checkIsFavourite(with: countryID) { result in
            switch result {
            case .success(let bool):
                bool ? self.saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : self.saveButton.setImage(UIImage(systemName: "star"), for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }
}
