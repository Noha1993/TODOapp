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
    
    var selectedText: String? //遷移用
    var selectedId: String?
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        todos = []
        //Firebaseからデータを取得する処理
        let dataGet = GetData()
        dataGet.request { getData -> Void in
            self.todos = getData
            self.tableView.reloadData()
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
                    "date": "",
                    "createdAt": Timestamp(date: Date())
                ]
                todoAdd.setData(todoData)
                //追加したデータをtodosに追加
                let post = Todo(todoData: todoData)
                self.todos.append(post)
                //ビューの更新
                self.tableView.reloadData()
            }
        }
        //キャンセルボタンが押されたときの動作
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        //alertControllerのtextFieldのplaceholder
        alertController.addTextField { (textField) in
            textField.placeholder = "Todoの名前を入れてください"
        }
        
        alertController.addAction(action)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let todo = todos[indexPath.row]
        
        cell.todoLabel.text = todo.todo
        cell.timeLabel.text = todo.date
        
        return cell
    }
    
    //セルの高さ
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //データの削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let deleteID = todo.todoID
        Firestore.firestore().collection("todo").document(deleteID).delete()
        
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    //セルがタップされたときの動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedText = todos[indexPath.row].todo
        selectedId = todos[indexPath.row].todoID
        selectedDate = todos[indexPath.row].date
        //セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        //画面遷移
        performSegue(withIdentifier: "todoDetail", sender: nil)
    }
    
    //遷移するときのデータの受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "todoDetail") {
            let secondVC: TodoDetailViewController = (segue.destination as? TodoDetailViewController)!
            
            secondVC.selectedId = selectedId!
            secondVC.text = selectedText!
            secondVC.selectedDate = selectedDate!
        }
    }
}
