//
//  AddItemTableViewController.swift
//  Fleur
//
//  Created by Dawid Nadolski on 30/06/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

import UIKit

protocol AddTaskViewControllerDelegate: class {
    
    func addTaskViewControllerDidCancel(_ controller: AddTaskTableViewController)
    func addTaskViewController(_ controller: AddTaskTableViewController, didFinishAdding task: Task)
    func addTaskViewController(_ controller: AddTaskTableViewController, didFinishEditing task: Task)
}

final class AddTaskTableViewController: UITableViewController {
    
    weak var delegate: AddTaskViewControllerDelegate?
    var taskToEdit: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = taskToEdit {
            title = "Edit Task"
            textfield.text = task.name
            doneBarButton.isEnabled = true
            
        } else {
            title = "Add Task"
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addTaskViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let task = taskToEdit {
            if let taskName = textfield.text {
                task.name = taskName
                delegate?.addTaskViewController(self, didFinishEditing: task)
            }
        } else {
            if let taskName = textfield.text {
                let task = Task(name: taskName)
                delegate?.addTaskViewController(self, didFinishAdding: task)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    }
}

extension AddTaskTableViewController: UITextFieldDelegate {
    // method called when the user taps the keyboard’s return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return false
    }
    
    // method called every time current text changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textfield.text,
            let stringRange = Range(range, in: oldText) else {
                return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
}
