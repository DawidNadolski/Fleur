//
//  File.swift
//  Fleur
//
//  Created by Dawid Nadolski on 11/07/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

import UIKit

class Plant {
    
    var name: String
    var species: String
    var image: UIImage?
    
    init(name: String, species: String) {
        self.name = name
        self.species = species
        image = nil
    }
    
    init(name: String) {
        self.name = name
        species = ""
        image = nil
    }
    
    init() {
        self.name = ""
        species = ""
        image = nil
    }
}

extension Plant: Equatable {
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        lhs.name == rhs.name && lhs.species == rhs.species
    }
    
    
}
