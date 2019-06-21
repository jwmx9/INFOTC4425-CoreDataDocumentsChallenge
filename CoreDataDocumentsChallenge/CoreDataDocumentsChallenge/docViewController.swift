//
//  docViewController.swift
//  CoreDataDocumentsChallenge
//
//  Created by John Williams III on 6/16/19.
//  Copyright © 2019 John Williams III. All rights reserved.
//

import UIKit
import CoreData

class docViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var docTextField: UITextField!
    @IBOutlet weak var docDescription: UITextView!
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let doc = doc{
            docTextField.text = doc.docName
            docDescription.text = doc.docDescription
        }
        
        if docTextField.text != "" {
            isExisting = true
        }
        
        
        docTextField.delegate = self
        docDescription.delegate = self
        // Do any additional setup after loading the view.
    }
    
    var notesFetchedResultsController: NSFetchedResultsController<Document>!
    var docs = [Document]()
    var doc: Document?
    var isExisting = false
    var indexPath: Int?
    
    
    func saveToCoreData(completion: @escaping ()-> Void){
        managedObjectContext?.perform {
            do{
                try self.managedObjectContext?.save()
                completion()
                print("Doc saved to core data")
            }
            catch let error {
                print("Could not save: \(error.localizedDescription)")
            }

        }
    }
    
    
    @IBAction func saveButtonWasPressed(_ sender: UIBarButtonItem) {
        if docTextField.text == "" || docTextField.text == "Document Name..." || docDescription.text == "" || docDescription.text == "Contents..." {
            let alertController = UIAlertController(title: "Missing Info", message: "One or more fields missing, please fill in order to save", preferredStyle: UIAlertController.Style.alert)
            let OKaction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(OKaction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if(isExisting == false){
                let noteName = docTextField.text
                let noteDescription = docDescription.text
                
                if let moc = managedObjectContext{
                    let note = Document(context: moc)
                    
                    note.docName = noteName
                    note.docDescription = noteDescription
                    
                    saveToCoreData {
                        let isPresentingInAddNoteMode = self.presentingViewController is UINavigationController
                        if isPresentingInAddNoteMode {
                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                            self.navigationController!.popViewController(animated: true)
                        }
                    }
                    
                }
            }
        }
        if (isExisting == true){
            
            let note = self.doc
            
            let managedObject = note
            managedObject!.setValue(docTextField.text, forKey: "docName")
            managedObject!.setValue(docDescription.text, forKey: "docDescription")
        
            do {
                
                try context.save()
                let isPresentingInAddNoteMode = self.presentingViewController is UINavigationController
                
                if isPresentingInAddNoteMode {
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    self.navigationController!.popViewController(animated: true)
                }
            }
                
            catch {
                print("Failed to update document")
            }
        }
 
    }
    
    @IBAction func cancelPress(_ sender: UIBarButtonItem) {
        
        let isPresentingInAddNoteMode = self.presentingViewController is UINavigationController
        if isPresentingInAddNoteMode {
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.navigationController!.popViewController(animated: true)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
        textView.resignFirstResponder()
        return false
    
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Content..."){
            textView.text = ""
        }
    }

}

