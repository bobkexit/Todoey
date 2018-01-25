//
//  CategoryVC.swift
//  Todoey
//
//  Created by Николай Маторин on 24.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipeTableVC {

    var catigories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        reloadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = catigories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.hexColor)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catigories?.count ?? 0
    }
    
    override func upadateModel(atIndexPath indexPath: IndexPath) {
        
        guard let category = self.catigories?[indexPath.row] else {
            return
        }
        
        RealmDataService.sharedInstance.remove(category)
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: GO_TO_ITEMS, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListVC
       
        if let indexPath = tableView.indexPathForSelectedRow {
             destinationVC.selectedCategory = catigories?[indexPath.row]
        }
    
    }
    
    //MARK: - Add New Category
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            guard let name = textField.text, !name.isEmpty else {
                return
            }
            
            let newCategory = Category()
            newCategory.name = name
            
            RealmDataService.sharedInstance.save(category: newCategory)
            
            self.reloadCategories()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
       
        alert.preferredAction = addAction
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func reloadCategories() {
        catigories = RealmDataService.sharedInstance.realm.objects(Category.self)
        tableView.reloadData()
    }
}
