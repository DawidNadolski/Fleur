//
//  Task.swift
//  Fleur
//
//  Created by Dawid Nadolski on 17/06/2020.
//  Copyright © 2020 Dawid Nadolski. All rights reserved.
//

import Foundation

class Task {
    
    var name: String
    var completed = false
    var date: Date?
    
    func toggleChecked() {
        completed = !completed
    }
    
    public func isCompleted() -> Bool {
        return completed
    }
    
    public init(name: String) {
        self.name = name
    }
    
    public init() {
        name = ""
        completed = false
    }
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.name == rhs.name
    }
}
