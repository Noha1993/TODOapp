//
//  TodoDetailViewController.swift
//  TODOapp
//
//  Created by KAZUMA NOHA on 2019/12/14.
//  Copyright © 2019 KAZUMA NOHA. All rights reserved.
//

import UIKit
import Firebase

class TodoDetailViewController: UIViewController, UITextFieldDelegate {
    
    var text: String = ""
    var selectedId: String = ""
    var selectedDate: String = ""
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var todoText: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoText.delegate = self
        
        //TodoTableViewControllerからの値受け渡し
        todoText.text = text
        dateTextField.text = selectedDate
        
        //ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale(identifier: "ja")
        dateTextField.inputView = datePicker
        
        //決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        //インプットビュー設定(紐づいているUITextfieldへ代入)
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    //dateTextFieldの設定
    @objc func done() {
        dateTextField.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
    }
    
    //ビューが遷移するときにFirestoreの値を更新する
    override func viewWillDisappear(_ animated: Bool) {
        let updateText = todoText.text
        let dateText = dateTextField.text
        Firestore.firestore().collection("todo").document(selectedId).updateData([
            "todo": updateText,
            "date": dateText
        ])
    }
    
    //Returnボタンでキーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //画面をタップするとキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
