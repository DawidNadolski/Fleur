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
    var filteredPlants: [Plant] = []
    
    var isSearchBarEmpty: Bool {
        return navigationItem.searchController?.searchBar.text?.isEmpty ?? true
    }
    
    var isAtLeastOneRowSelectedInEditingMode: Bool {
        return tableView.indexPathsForSelectedRows == nil ? false : true
    }
    
    var isFiltering: Bool {
        return navigationItem.searchController!.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet private weak var deleteBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Plants"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
            deleteBarButton.isEnabled = false
            tableView.endUpdates()
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
        let plant: Plant
        
        if isFiltering {
            plant = filteredPlants[indexPath.row]
        } else {
            plant = plantsList.plants[indexPath.row]
        }
        
        configureText(for: cell, with: plant)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlants.count
        }
        return plantsList.plants.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            deleteBarButton.isEnabled = isAtLeastOneRowSelectedInEditingMode
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        deleteBarButton.isEnabled = isAtLeastOneRowSelectedInEditingMode
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        plantsList.plants.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPlantSegue" {
            if let addPlantViewController = segue.destination as? AddPlantViewController {
                addPlantViewController.delegate = self
            }
        }
        if segue.identifier == "EditPlantSegue" {
            if let addPlantViewController = segue.destination as? AddPlantViewController {
                addPlantViewController.delegate = self
                if let cell = sender as? UITableViewCell {
                    if let indexPath = tableView.indexPath(for: cell) {
                        let plant = plantsList.plants[indexPath.row]
                        addPlantViewController.plantToEdit = plant
                    }
                }
            }
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: Plant) {
        if let plantCell = cell as? PlantsTableViewCell {
            plantCell.plantLabel.text = item.name
            plantCell.speciesLabel.text = item.species
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredPlants = plantsList.plants.filter {(plant: Plant) -> Bool in
            return plant.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension PlantsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension PlantsViewController: AddPlantViewControllerDelegate {
    
    func addPlantViewControllerDidCancel(_ controller: AddPlantViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addPlantViewController(_ controller: AddPlantViewController, didFinishAdding plant: Plant) {
        let rowIndex = plantsList.plants.count
        plantsList.plants.append(plant)
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func addPlantViewController(_ controller: AddPlantViewController, didFinishEditing plant: Plant) {
        if let index = plantsList.plants.firstIndex(of: plant) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: plant)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
