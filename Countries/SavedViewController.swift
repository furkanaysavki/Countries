//
//  SavedViewController.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 10.04.2022.
//

import UIKit
import CoreData

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var nameArray = [String]()
    var codeArray = [String]()
    var chosenCode = ""
   
    
    @IBOutlet weak var savedCountryView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        getName()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getName), name: NSNotification.Name(rawValue : "newData"), object: nil)
    }
    
    @objc func getName () {
        
        nameArray.removeAll(keepingCapacity: false)
        codeArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Countries")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey : "name") as? String {
                    self.nameArray.append(name)
                }
                if let code = result.value(forKey : "code") as? String {
                    self.codeArray.append(code)
                }
              
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell") as! SavedCell
        cell.countryLabel.text = nameArray[indexPath.row]
        cell.codeLabel.text = codeArray[indexPath.row]
        cell.savedCountryView.layer.cornerRadius = cell.savedCountryView.frame.height / 2
       
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        chosenCode = codeArray[indexPath.row]
          
           performSegue(withIdentifier: "DetailsVC", sender: nil)
    }
           
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "DetailsVC" {
               let destinationVC = segue.destination as! DetailsVC
               destinationVC.selectedCode = chosenCode
               
           }

}
    
       
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
               
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Countries")
                
                let nameString = nameArray[indexPath.row]
                let codeString = codeArray[indexPath.row]
                
                fetchRequest.predicate = NSPredicate(format: "name = %@ ", nameString)
                fetchRequest.predicate = NSPredicate(format: "code = %@ ", codeString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        
                        for result in results as! [NSManagedObject] {
                            
                            if let name = result.value(forKey: "name") as? String {
                                
                                if name == nameArray[indexPath.row] {
                                    context.delete(result)
                                    nameArray.remove(at: indexPath.row)
                                    if let code = result.value(forKey: "code") as? String{
                                        if code == codeArray[indexPath.row]{
                                            context.delete(result)
                                            codeArray.remove(at: indexPath.row)
                                    }
                                    }
                                    self.tableView.reloadData()
                                    
                                    do {
                                        try context.save()
                                        
                                    } catch {
                                        print("error")
                                    }
                                    
                                    break
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                    }
                } catch {
                    print("error")
                }
                
                
                
                
    }
        }
        
        
}
