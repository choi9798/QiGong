//
//  Menu_ViewController.swift
//  QiGong
//
//  Created by mac on 22/12/2017.
//  Copyright © 2017 ncku. All rights reserved.
//

import UIKit

class Menu_ViewController: UIViewController {
    @IBOutlet weak var monitor_btn: UIButton!
    @IBOutlet weak var train_btn: UIButton!
    @IBAction func monitor_pressed(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoMonitor_segue", sender: nil)
    }
    @IBAction func train_pressed(_ sender: UIButton) {
        
    }
    
    var userInfo: [user_info] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoMonitor_segue" {
            let monitor = segue.destination as! Monitor_ViewController
            monitor.userinfo = userInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userInfo)
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }

}
