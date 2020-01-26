//
//  ListTableViewController.swift
//  Database
//
//  Created by Md. Mazidul Islam on 26/1/20.
//  Copyright © 2020 Md. Mazidul Islam. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    var items = [Item]()
    var defaults = UserDefaults.standard
    let key = "data"
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()

    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentItem = items[indexPath.row]
        currentItem.done = !currentItem.done
        addItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Actions

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add List Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            newItem.done = true
            self.items.append(newItem)
            self.tableView.reloadData()
            self.addItem()
        }
        
        alert.addTextField { (editTextField) in
            textField = editTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Custome Function
    
    func addItem(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try! data.write(to: filePath!)
            print("Success!")
        } catch {
            print("Error in Save!:\(error)")
        }
        tableView.reloadData()

    }
    
    func loadItem(){
        if let data = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            do {
                try items = decoder.decode([Item].self, from: data)
            } catch {
                print("Error in Load!:\(error)")
            }
        }
    }
    
}
