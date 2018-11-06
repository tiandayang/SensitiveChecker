//
//  ViewController.swift
//  SensitiveChecker
//
//  Created by 田向阳 on 2018/11/6.
//  Copyright © 2018 田向阳. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var checker = SensitiveChecker.shared

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func check(_ sender: Any) {
       let result = checker.filterSensitiveWords(text: self.textField.text ?? "")        
        self.textField.text = result.1
    }
    
}

