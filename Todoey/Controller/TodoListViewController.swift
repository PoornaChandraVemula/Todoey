//
//  ViewController.swift
//  Todoey
//
//  Created by Poorna Chandra Vemula on 20/05/19.
//  Copyright © 2019 Poorna Chandra Vemula. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            cell.backgroundColor = UIColor(hexString: item.color)
            //Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
        
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    
                    item.done = !item.done
                }
            } catch {
                print("Error Saving done Status \(error)")
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func updateModel(indexPath: IndexPath) {
        
        if let itemDeleted = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemDeleted)
                }
            } catch {
            print("Item could not be deleted \(error).")
            }
        }
    }
    
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert

            
            if let currentCategory = self.selectedCategory {
                
               do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        newItem.color = (UIColor.randomFlat()?.hexValue()!)!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error Saving new Item \(error)")
                }
                self.tableView.reloadData()
            }
            
            
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }


        alert.addAction(action)

        present(alert, animated: true, completion: nil)

    }
    
    //MARK - Model Manupulation Methods
    
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
    

}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


