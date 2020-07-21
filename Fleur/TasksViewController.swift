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
        if segue.identifier == "AddTaskSegue" {
            if let addTaskViewController = segue.destination as? AddTaskTableViewController {
                addTaskViewController.delegate = self
            }
        } else if segue.identifier == "EditTaskSegue" {
            if let addTaskViewController = segue.destination as? AddTaskTableViewController {
                addTaskViewController.delegate = self
                if let cell = sender as? UITableViewCell {
                    if let indexPath = tableView.indexPath(for: cell) {
                        let task = tasksList.tasks[indexPath.row]
                        addTaskViewController.taskToEdit = task
                    }

                }
            }
        }
    }
    
    func configureText(for cell: UITableViewCell, with task: Task) {
        if let taskCell = cell as? TasksTableViewCell {
            taskCell.taskLabel.attributedText = NSAttributedString(string: task.name)
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with task: Task) {
        
        if let taskCell = cell as? TasksTableViewCell {
            print("Got here!")
            guard let taskLabel = taskCell.taskLabel,
                let taskName = taskLabel.text else {
                    print("TasksViewControler: configureCheckmark(): couldn't find taskLabel or taskName")
                    return
            }
            
            if task.isCompleted() {
                let completedAttributedString = NSMutableAttributedString(string: taskName)
                completedAttributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, completedAttributedString.length))
                taskLabel.attributedText = completedAttributedString
            } else {
                taskLabel.attributedText = NSAttributedString(string: taskName)
            }
            
            task.toggleChecked()
        }
    }
}

extension TasksViewController: AddTaskViewControllerDelegate {
    func addTaskViewController(_ controller: AddTaskTableViewController, didFinishAdding task: Task) {
        let rowIndex = tasksList.tasks.count
        tasksList.tasks.append(task)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func addTaskViewController(_ controller: AddTaskTableViewController, didFinishEditing task: Task) {
        if let index = tasksList.tasks.firstIndex(of: task) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: task)
            }
        }
        navigationController?.popViewController(animated: true)
    }

    func addTaskViewControllerDidCancel(_ controller: AddTaskTableViewController) {
        navigationController?.popViewController(animated: true)
    }
}
