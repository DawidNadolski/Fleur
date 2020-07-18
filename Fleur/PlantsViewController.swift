//
//  PlantsViewController.swift
//  Fleur
//
//  Created by Dawid Nadolski on 09/07/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

import UIKit

class PlantsViewController: UITableViewController {
    
    var plantsList = PlantsList()
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            deleteBarButton.isEnabled = true
            var items = [Plant]()
            for indexPath in selectedRows {
                items.append(plantsList.plants[indexPath.row])
            }
            plantsList.remove(items)
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        } else {
            deleteBarButton.isEnabled = false
        }
    }
        
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = plantsList.plants[sourceIndexPath.row]
        plantsList.move(item, to: destinationIndexPath.row)
        tableView.reloadData()
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Plant", for: indexPath)
        let item = plantsList.plants[indexPath.row]
        configureText(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantsList.plants.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            deleteBarButton.isEnabled = !noRowsSelectedInEditingMode()
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        deleteBarButton.isEnabled = !noRowsSelectedInEditingMode()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        plantsList.plants.remove(at: indexPath.row)
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
    
    func configureText(for cell: UITableViewCell, with item: Plant) {
        if let plantCell = cell as? PlantsTableViewCell {
            plantCell.plantLabel.text = item.name
            plantCell.speciesLabel.text = item.species
        }
    }
    
    func noRowsSelectedInEditingMode() -> Bool {
        if tableView.indexPathsForSelectedRows == nil {
            return true
        } else {
            return false
        }
    }
}

extension PlantsViewController: AddItemViewControllerDelegate {
    func addItemViewControllerDidFinishAddingItem(_ controller: AddItemTableViewController, withTitle itemName: String) {
        let newPlant = Plant(name: itemName)
        let rowIndex = plantsList.plants.count
        plantsList.plants.append(newPlant)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func addItemViewControllerDidCancel(_ controller: AddItemTableViewController) {
        navigationController?.popViewController(animated: true)
    }
}
