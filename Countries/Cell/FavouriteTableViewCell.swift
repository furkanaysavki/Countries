//
//  FavouriteTableViewCell.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 29.10.2022.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    static let identifier = String(describing: FavouriteTableViewCell.self)
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var countryName: UILabel!
    var countryID = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 3
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
