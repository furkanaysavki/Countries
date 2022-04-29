//
//  HomeCell.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 8.04.2022.
//

import UIKit
import CoreData

class HomeCell: UITableViewCell, UINavigationControllerDelegate {
    
    
   
    @IBOutlet weak var countryName: UILabel!
    
    @IBOutlet weak var countryView: UIView!
    
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        codeLabel.isHidden = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newCountry = NSEntityDescription.insertNewObject(forEntityName: "Countries", into: context)
        newCountry.setValue(countryName.text!, forKey: "name")
        newCountry.setValue(codeLabel.text!, forKey: "code")
        
       
        do{
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        
    }
    
}
