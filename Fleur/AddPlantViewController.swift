//
//  AddPlantTableViewController.swift
//  Fleur
//
//  Created by Dawid Nadolski on 19/07/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

import UIKit

protocol AddPlantViewControllerDelegate: class {
    func addPlantViewControllerDidCancel(_ controller: AddPlantViewController)
    func addPlantViewController(_ controller: AddPlantViewController, didFinishAdding plant: Plant)
    func addPlantViewController(_ controller: AddPlantViewController, didFinishEditing plant: Plant)
}

class AddPlantViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    weak var delegate: AddPlantViewControllerDelegate?
    var plantToEdit: Plant?
    
    @IBOutlet private weak var plantNameTextfield: UITextField!
    @IBOutlet private weak var plantSpeciesTextfield: UITextField!
    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let plant = plantToEdit {
            plantNameTextfield.text = plant.name
            plantSpeciesTextfield.text = plant.species
            title = "Edit Plant"
        } else {
            title = "Add Plant"
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addPlantViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        
        if let plant = plantToEdit {
            guard let plantName = plantNameTextfield.text,
                let plantSpecies = plantSpeciesTextfield.text else {
                return
            }
            plant.name = plantName
            plant.species = plantSpecies
            delegate?.addPlantViewController(self, didFinishEditing: plant)
        } else {
            guard let plantName = plantNameTextfield.text,
                let plantSpecies = plantSpeciesTextfield.text else {
                return
            }
            let plant = Plant(name: plantName, species: plantSpecies)
            delegate?.addPlantViewController(self, didFinishAdding: plant)
        }
    }
    
    @objc func dismissKeyboard() {
        tableView.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        plantNameTextfield.becomeFirstResponder()
    }
}

extension AddPlantViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let stringRange = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
}
