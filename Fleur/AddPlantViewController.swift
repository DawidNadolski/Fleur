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
}

class AddPlantViewController: UITableViewController {
    
    weak var delegate: AddPlantViewControllerDelegate?
    var plantToEdit: Plant?
    
    @IBOutlet weak var plantNameTextfield: UITextField!
    @IBOutlet weak var plantSpeciesTextfield: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let plant = plantToEdit {
            plantNameTextfield.text = plant.name
            plantSpeciesTextfield.text = plant.species
            title = "Edit Plant"
        } else {
            title = "Add Plant"
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate?.addPlantViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        guard let plantName = plantNameTextfield.text,
            let plantSpecies = plantSpeciesTextfield.text else {
            return
        }
        let plant = Plant(name: plantName, species: plantSpecies)
        delegate?.addPlantViewController(self, didFinishAdding: plant)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        plantNameTextfield.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
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
