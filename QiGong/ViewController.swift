//
//  ViewController.swift
//  QiGong
//
//  Created by mac on 15/12/2017.
//  Copyright © 2017 ncku. All rights reserved.
//

import UIKit

struct user_info {
    let name: String
    let height: Int
    let weight: Int
    let age: Int
}

class ViewController: UIViewController {
    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var name_textField: UITextField!
    @IBOutlet weak var height_textField: UITextField!
    @IBOutlet weak var weight_textField: UITextField!
    @IBOutlet weak var age_textField: UITextField!
    @IBOutlet weak var submit_btn: UIButton!
    
    var info: [user_info] = []
    
    @IBAction func submit(_ sender: UIButton) {
        guard name_textField.text?.isEmpty == false else {
            error_label.isHidden = false
            return
        }
        guard height_textField.text?.isEmpty == false else {
            error_label.isHidden = false
            return
        }
        guard weight_textField.text?.isEmpty == false else {
            error_label.isHidden = false
            return
        }
        guard age_textField.text?.isEmpty == false else {
            error_label.isHidden = false
            return
        }
        info.append(user_info(name: name_textField.text!, height: Int(height_textField.text!)!, weight: Int(weight_textField.text!)!, age: Int(age_textField.text!)!))
        
        performSegue(withIdentifier: "gotoMenu_segue", sender: submit_btn)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoMenu_segue" {
            let menu_viewcontroller = segue.destination as! Menu_ViewController
            menu_viewcontroller.userInfo = info
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        error_label.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

