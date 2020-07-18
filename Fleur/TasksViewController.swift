//
//  ViewController.swift
//  Fleur
//
//  Created by Dawid Nadolski on 17/06/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController {
    
    var tasksList = TasksList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        let item = tasksList.tasks[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = tasksList.tasks[indexPath.row]
            configureCheckmark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tasksList.tasks.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addItemViewController = segue.destination as? AddItemTableViewController {
                addItemViewController.delegate = self
            }
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: Task) {
        if let taskCell = cell as? TasksTableViewCell {
            taskCell.taskLabel.text = item.name
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: Task) {
        if item.isCompleted() {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        item.toggleChecked()
    }
}

extension TasksViewController: AddItemViewControllerDelegate {
    func addItemViewControllerDidFinishAddingItem(_ controller: AddItemTableViewController, withTitle itemName: String) {
        let newTask = Task(name: itemName)
        let rowIndex = tasksList.tasks.count
        tasksList.tasks.append(newTask)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) {
        navigationController?.popViewController(animated: true)
    }
}
