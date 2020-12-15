//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Moshiur Rahman Bilash on 15/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [Person]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // fetch items from core data
        fetchPeople()
    }
    @IBAction func addPeople(_ sender: Any) {
        let alert = UIAlertController(title: "Add People", message: "Add people you know..", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in

            let textfield = alert.textFields![0]
            
            // create a new person object
            let newPerson = Person(context: context)
            newPerson.name = textfield.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            do {
                try self.context.save()
            } catch {
                //
            }
            
            fetchPeople()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    func fetchPeople() {
        do {
            self.items = try context.fetch(Person.fetchRequest())
        } catch {
            //
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    


}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let person = self.items?[indexPath.row]
        cell.textLabel?.text = person?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            //Which Person to remove
            let personToRemove = self.items![indexPath.row]
            
            // Remove the person
            self.context.delete(personToRemove)
            
            //Save the data
            do {
                try self.context.save()
            } catch {
                //
            }
            
            //Refetch the data
            self.fetchPeople()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = self.items![indexPath.row]
        let alert = UIAlertController(title: "Edit Person", message: "Edit Person Name", preferredStyle: .alert)
        alert.addTextField()
        let textfield = alert.textFields![0]
        textfield.text = person.name
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (acion) in
            let textfield = alert.textFields![0]
            
            // update
            person.name = textfield.text
            
            // save
            do {
                try self.context.save()
            } catch {
                //
            }
            
            //Refetch the data
            self.fetchPeople()
        }
        alert.addAction(updateAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}
