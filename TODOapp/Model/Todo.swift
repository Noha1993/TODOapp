//
//  Todo.swift
//  TODOapp
//
//  Created by KAZUMA NOHA on 2019/12/13.
//  Copyright © 2019 KAZUMA NOHA. All rights reserved.
//

import UIKit
import Firebase

struct Todo {
    let todoID: String
    let todo: String
    let date: String
    let createdAt: Timestamp
    
    init(todoData: [String: Any]) {
        todoID = todoData["todoID"] as! String
        todo = todoData["todo"] as! String
        date = todoData["date"] as! String
        createdAt = todoData["createdAt"] as! Timestamp
    }
}
