//
//  TaskStore.swift
//  Fleur
//
//  Created by Dawid Nadolski on 17/06/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

class TasksList {
    
    var tasks = [
        "Take a jog",
        "Watch a movie",
        "Code an app",
        "Walk the dog",
        "Study design patterns",
        ].map { Task(name: $0) }
    
    func move(item: Task, to index: Int) {
        guard let currentIndex = tasks.firstIndex(of: item) else {
            return
        }
        
        tasks.remove(at: currentIndex)
        tasks.insert(item, at: index)
    }
}

