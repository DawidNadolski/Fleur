//
//  PlantsList.swift
//  Fleur
//
//  Created by Dawid Nadolski on 11/07/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

class PlantsList {
    
    var plants = [Plant(name: "Pyszczek", species: "Monstera"),
                  Plant(name: "Wiktoria", species: "Kaktus"),
                  Plant(name: "Dawid", species: "Paproć")]
    
    func move(_ item: Plant, to index: Int) {
        guard let currentIndex = plants.firstIndex(of: item) else {
            return
        }
        plants.remove(at: currentIndex)
        plants.insert(item, at: index)
    }
    
    func remove(_ items: [Plant]) {
        for item in items {
            if let index = plants.firstIndex(of: item) {
                plants.remove(at: index)
            }
        }
    }
}
