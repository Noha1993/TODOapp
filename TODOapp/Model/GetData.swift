//
//  GetData.swift
//  TODOapp
//
//  Created by KAZUMA NOHA on 2019/12/18.
//  Copyright © 2019 KAZUMA NOHA. All rights reserved.
//

import UIKit
import Firebase

class GetData {
    var gotTodos: [Todo] = []
    //Firebaseからデータを取得する。TodoTableViewControllerから呼び出し
    func request(completed: ( ([Todo]) -> Void)? ) {
        Firestore.firestore().collection("todo").order(by: "createdAt").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                for document in snapshot.documents {
                    
                    let data = document.data()
                    let post = Todo(todoData: data)
                    self.gotTodos.append(post)
                    completed?(self.gotTodos)
                }
            }
        }
    }
}
