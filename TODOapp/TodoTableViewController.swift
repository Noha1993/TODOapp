//
//  TodoTableViewController.swift
//  TODOapp
//
//  Created by KAZUMA NOHA on 2019/12/12.
//  Copyright © 2019 KAZUMA NOHA. All rights reserved.
//

import UIKit
import Firebase

class TodoTableViewController: UITableViewController {
    
    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        todos = []
        Firestore.firestore().collection("todo").order(by: "createdAt").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let post = Todo(todoData: data)
                    self.todos.append(post)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //+ボタンが押されたときの処理
    @IBAction func addButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "新しいタスク", message: nil, preferredStyle: .alert)
        //追加ボタンが押されたときの動作
        let action: UIAlertAction = UIAlertAction(title: "追加", style: .default) {
            (void) in
            let textField = alertController.textFields![0] as UITextField
            if let text = textField.text {
                //FirebaseにTodoデータを追加する処理
                let todoAdd = Firestore.firestore().collection("todo").document()
                let todoID = todoAdd.documentID
                
                let todoData: [String: Any] = [
                    "todoID": todoID,
                    "todo": text,
                    "createdAt": Timestamp(date: Date())
                ]
                todoAdd.setData(todoData)
            }
            self.tableView.reloadData()
        }
        
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addTextField { (textField) in
            textField.placeholder = "Todoの名前を入れてください"
        }
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.todo
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // データの削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let deleteID = todo.todoID
        Firestore.firestore().collection("todo").document(deleteID).delete()
        
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
