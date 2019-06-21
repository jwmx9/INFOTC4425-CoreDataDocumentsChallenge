//
//  docTableViewController.swift
//  CoreDataDocumentsChallenge
//
//  Created by John Williams III on 6/16/19.
//  Copyright © 2019 John Williams III. All rights reserved.
//

import UIKit
import CoreData

class docTableViewController: UITableViewController {

    var docs = [Document]()
    
    var managedObjectContex: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieveNotes()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return docs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath) as! docTableViewCell

        let doc: Document = docs[indexPath.row]
        cell.configureCell(doc: doc)
        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
 
    func retrieveNotes(){
        managedObjectContex?.perform {
            self.fetchNotesFromCoreData { docs in
                if let docs = docs {
                    self.docs = docs
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchNotesFromCoreData(completion: @escaping (([Document]?) -> Void)) {
        managedObjectContex?.perform {
            var doc = [Document]()
            let request: NSFetchRequest<Document> = Document.fetchRequest()
            
            do {
                doc = try self.managedObjectContex!.fetch(request)
                completion(doc)
            }
            catch {
                print("Could not fetch items")
            }
        }
    }
    

}
