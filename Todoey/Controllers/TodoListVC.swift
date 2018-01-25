//
//  ViewController.swift
//  Todoey
//
//  Created by Николай Маторин on 23.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListVC: SwipeTableVC {

    var selectedCategory: Category? {
        didSet {
            reloadItems()
        }
    }

    var items: Results<Item>?
    var defaultBarTintColor: UIColor?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedCategory = selectedCategory {
            
            title = selectedCategory.name
            
            guard let color = UIColor(hexString: selectedCategory.hexColor) else {
                return
            }
            
            updateNavigationBar(withColor: color)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let color = defaultBarTintColor else {
            return
        }
        
        updateNavigationBar(withColor: color)
    }
    
    func updateNavigationBar(withColor color: UIColor) {
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        if defaultBarTintColor == nil {
            defaultBarTintColor =  navigationBar.barTintColor
        }
        
        searchBar.barTintColor = color
        navigationBar.barTintColor = color
        navigationBar.tintColor = ContrastColorOf(color, returnFlat: true)
        navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(color, returnFlat: true)]
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let hexColor = selectedCategory?.hexColor {
                cell.backgroundColor = UIColor(hexString: hexColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count))
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func upadateModel(atIndexPath indexPath: IndexPath) {
        
        guard let item = self.items?[indexPath.row] else {
            return
        }
        
        RealmDataService.sharedInstance.remove(item)
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = items?[indexPath.row] else {
            return
        }
        
        do {
            try RealmDataService.sharedInstance.realm.write {
                item.done = !item.done
            }
        } catch {
            print("Error trying update item, \(error)")
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
        
        //tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
           
            guard
                let category = self.selectedCategory,
                let text = textField.text, !text.isEmpty
            else {
                return
            }
            
            let newItem = Item()
            newItem.title = text
            
            RealmDataService.sharedInstance.save(item: newItem, forCategory: category)
            
            self.reloadItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func reloadItems() {
        
        guard let category = selectedCategory else {
            return
        }
        
        items = category.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
       
    }
    
}

//MARK: - Searchbar Delegate Methods

extension TodoListVC: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        items = items?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if !searchText.isEmpty { return }
        
        self.reloadItems()
        
        DispatchQueue.main.async {
             searchBar.resignFirstResponder()
        }
       
    }
}

