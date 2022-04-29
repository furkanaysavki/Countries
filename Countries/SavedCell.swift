//
//  SavedCell.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 10.04.2022.
//

import UIKit
import CoreData

class SavedCell: UITableViewCell {
    

   
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var favouriteButton: UIImageView!
    
    
    @IBOutlet weak var savedCountryView: UIView!
    
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        codeLabel.isHidden = true
        
        
                   
                    
                    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
