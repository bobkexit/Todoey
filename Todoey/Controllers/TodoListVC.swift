//
//  ViewController.swift
//  Todoey
//
//  Created by Николай Маторин on 23.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for i in 1...20 {
            let item = Item(title: "shopping\(i)")
            itemArray.append(item)
        }
        
//        if let todoListArray = defaults.array(forKey: TODO_LIST_ARRAY) as? [String] {
//            itemArray = todoListArray
//        }
    }

    //MARK: TableView DataSource Methods
    
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
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = itemArray[indexPath.row]
        selectedItem.done = !selectedItem.done
        
        tableView.cellForRow(at: indexPath)?.accessoryType = selectedItem.done ? .checkmark : .none
        //tableView.reloadRows(at: [indexPath], with: .automatic) //TODO: check this part tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: Add New Item
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            guard let text = textField.text, !text.isEmpty else {
                return
            }
            
            let newItem = Item(title: text)
            
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: TODO_LIST_ARRAY)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}

