//
//  TodoDetailViewController.swift
//  TODOapp
//
//  Created by KAZUMA NOHA on 2019/12/14.
//  Copyright © 2019 KAZUMA NOHA. All rights reserved.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    var text: String = ""
    
    
    @IBOutlet weak var todoText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        todoText.text = text
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
