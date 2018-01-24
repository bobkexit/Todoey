//
//  ViewController.swift
//  Todoey
//
//  Created by Николай Маторин on 23.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {

    var selectedCategory: Category? {
        didSet {
            reloadItems(withFilter: nil)
        }
    }
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadItems(withFilter: nil)
        
        if let selectedCategory = selectedCategory {
            navigationItem.title = selectedCategory.name
        }
        
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TODO_ITEM_CELL, for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = itemArray[indexPath.row]
        selectedItem.done = !selectedItem.done
        
        tableView.cellForRow(at: indexPath)?.accessoryType = selectedItem.done ? .checkmark : .none
        
//        itemArray.remove(at: indexPath.row)
//        DataService.sharedInstance.context.delete(selectedItem)
        
        DataService.sharedInstance.saveContext()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
           
            guard let text = textField.text, !text.isEmpty else {
                return
            }
            
            let newItem = Item(context: DataService.sharedInstance.context)
            newItem.title = text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            DataService.sharedInstance.saveContext()
            
            self.reloadItems(withFilter: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func reloadItems(withFilter filter: String?) {
        
        guard let category = selectedCategory else {
            return
        }
        
        DataService.sharedInstance.loadItems(forCategory: category, andFilteredBy: filter) { (filteredItems) in
            self.itemArray = filteredItems
            self.tableView.reloadData()
        }
        
    }
    
}

//MARK: - Searchbar Delegate Methods

extension TodoListVC: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        self.reloadItems(withFilter: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if !searchText.isEmpty { return }
        
        self.reloadItems(withFilter: nil)
        
        DispatchQueue.main.async {
             searchBar.resignFirstResponder()
        }
       
    }
}

