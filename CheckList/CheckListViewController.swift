//
//  ViewController.swift
//  CheckList
//
//  Created by Kegan Ronholt on 8/3/21.
//

import UIKit

class CheckListViewController: UITableViewController {

    var itemArray = ["Get cheese","Get potatoes", "Do Laundry"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - Table View Delegatge Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New CheckList Item", message: "", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safeText = textField.text{
                self.itemArray.append(safeText)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
}



