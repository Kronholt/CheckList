//
//  ViewController.swift
//  CheckList
//
//  Created by Kegan Ronholt on 8/3/21.
//

import UIKit
import CoreData

class CheckListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].checked ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New CheckList Item", message: "", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safeText = textField.text{
                
                let newItem = Item(context: self.context)
                newItem.title = safeText
                newItem.checked = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation methods
    
    func saveItems(){
        do{
            try context.save()
        } catch{
            print("Error decoding itme array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){

        var newPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            newPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newPredicate, additionalPredicate])
        }
        
        request.predicate = newPredicate
        
        do{
            itemArray = try context.fetch(request)
        } catch{
            print(error)
        }
    }
}

//MARK: - UISearchBarDelegate

extension CheckListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        if let safeText = searchBar.text{
            if safeText != ""{
                
                let predicate = NSPredicate(format: "title CONTAINS[cd] %@", safeText)
                
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
                loadItems(with: request, predicate: predicate)
            }else{
                loadItems()
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
            
        }
    }
    
    
}



