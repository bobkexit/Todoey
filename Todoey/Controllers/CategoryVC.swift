//
//  CategoryVC.swift
//  Todoey
//
//  Created by Николай Маторин on 24.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {

    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CATEGORY_CELL, for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: GO_TO_ITEMS, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListVC
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
    
    //MARK: - Add New Category
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            guard let name = textField.text, !name.isEmpty else {
                return
            }
            
            let newCategory = Category(context: DataService.sharedInstance.context)
            newCategory.name = name
            
            DataService.sharedInstance.saveContext()
            
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
        DataService.sharedInstance.loadCategories { (fetchedCategories) in
            self.categoryArray = fetchedCategories
            self.tableView.reloadData()
        }
    }
}
