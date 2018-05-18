//
//  Monitor_ViewController.swift
//  QiGong
//
//  Created by mac on 22/12/2017.
//  Copyright © 2017 ncku. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class Monitor_ViewController: UIViewController {
    
    @IBOutlet weak var buttons_stack: UIStackView!
    @IBOutlet weak var exhale_textfield: UITextField!
    @IBOutlet weak var inhale_textfield: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var pause_btn: UIButton!
    @IBOutlet weak var remain_sec_label: UILabel!
    @IBOutlet weak var remain_min_label: UILabel!
    @IBOutlet weak var remaintime_stack: UIStackView!
    @IBOutlet weak var ready_time_label: UILabel!
    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var status_stack: UIStackView!
    @IBOutlet weak var time_stack: UIStackView!
    @IBOutlet weak var min_textfield: UITextField!
    @IBOutlet weak var sec_textfield: UITextField!
    @IBAction func time_ok_pressed(_ sender: UIButton) {
        guard min_textfield.text?.isEmpty == false else {
            error_label.text = "不能有空格"
            error_label.isHidden = false
            return
        }
        guard sec_textfield.text?.isEmpty == false else {
            error_label.text = "不能有空格"
            error_label.isHidden = false
            return
        }
        guard inhale_textfield.text?.isEmpty == false else {
            error_label.text = "不能有空格"
            error_label.isHidden = false
            return
        }
        guard exhale_textfield.text?.isEmpty == false else {
            error_label.text = "不能有空格"
            error_label.isHidden = false
            return
        }
        if(Int(min_textfield.text!)! == 0 && Int(sec_textfield.text!)! == 0) {
            error_label.text = "時間不能為0"
            error_label.isHidden = false
            return
        }
        else if(Double(inhale_textfield.text!)! == 0 || Double(exhale_textfield.text!)! == 0) {
            error_label.text = "吸氣呼氣時間不能為0"
            error_label.isHidden = false
            return
        }
        
        minute = Int(min_textfield.text!)!
        second = Int(sec_textfield.text!)!
        inhale_time = Int(inhale_textfield.text!)! - 1
        exhale_time = Int(exhale_textfield.text!)! - 1
        time_stack.isHidden = true
        error_label.isHidden = true
        ready_time_label.isHidden = false
        print("\(minute)\t\(second)")
        remain_min_label.text = "\(minute)"
        remain_sec_label.text = "\(second)"
        min_textfield.resignFirstResponder()
        sec_textfield.resignFirstResponder()
        readytime = 5
        ready_time_label.text = "\(readytime)"
        readycount()
    }
    @IBAction func pause_pressed(_ sender: UIButton) {
        if(pause == true) {
            pause_btn.setTitle("暫停", for: .normal)
            pause = false
            counter()
        } else {
            timer.invalidate()
            pause_btn.setTitle("繼續", for: .normal)
            pause = true
        }
    }
    @IBAction func reset_pressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "確定要重設嗎", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "是", style: .default, handler: { action in
            self.timer.invalidate()
            self.time_stack.isHidden = false
            self.img.isHidden = true
            self.buttons_stack.isHidden = true
            self.player?.stop()
        }))
        self.present(alert, animated: true)
    }
    
    var userinfo: [user_info] = []
    var minute:Int = 0
    var second:Int = 0
    var readytime:Int = 5
    var timer = Timer()
    var pause:Bool = false
    var inhale_time:Int = 0
    var exhale_time:Int = 0
    var breathing_count:Int = 0
    var isInhale:Bool = true
    var player: AVAudioPlayer?
    let ref = Database.database().reference(fromURL: "https://qigongapp-dd8cf.firebaseio.com/")
    let average: Double = 12.1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userinfo)
        status_stack.isHidden = true
        error_label.isHidden = true
        ready_time_label.text = "\(readytime)"
        ready_time_label.isHidden = true
        remaintime_stack.isHidden = true
        buttons_stack.isHidden = true
        img.isHidden = true
    }
    
    func readycount() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(readycount_update), userInfo: nil, repeats: true)
    }
    
    @objc func readycount_update() {
        if(readytime <= 0) {
            timer.invalidate()
            ready_time_label.isHidden = true
            status_stack.isHidden = false
            remaintime_stack.isHidden = false
            buttons_stack.isHidden = false
            img.isHidden = false
            breathing_count = 0
            isInhale = true
            playSound(soundname: "inhale_sound")
            counter()
        } else {
            readytime-=1;
            ready_time_label.text = "\(readytime)"
        }
    }
    
    func counter() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
    }
    
    @objc func count() {
        if(minute <= 0 && second <= 1) {
            timer.invalidate()
            player?.stop()
            time_stack.isHidden = false
            img.image = UIImage(named: "inhale.png")
            img.isHidden = true
            remaintime_stack.isHidden = true
            buttons_stack.isHidden = true
            
            let endingAlert = UIAlertController(title: "你這次平均呼吸時間為 2 秒/次", message: "", preferredStyle: UIAlertControllerStyle.alert)
            endingAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(endingAlert, animated: true)
            
            uploadData();
            
        } else if(second == 0) {
            if(minute > 0) {
                minute -= 1;
                second = 59;
            }
            remain_min_label.text = "\(minute)"
            remain_sec_label.text = "\(second)"
        } else {
            second -= 1;
            remain_min_label.text = "\(minute)"
            remain_sec_label.text = "\(second)"
        }
        if(breathing_count == inhale_time && isInhale) {
            img.image = UIImage(named: "exhale.png")
            playSound(soundname: "exhale_sound")
            isInhale = false
            breathing_count = 0
        } else if(breathing_count == exhale_time && !isInhale) {
            img.image = UIImage(named: "inhale.png")
            playSound(soundname: "inhale_sound")
            isInhale = true
            breathing_count = 0
        } else {
            breathing_count+=1
        }
        
    }
    
    func uploadData() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let today:String = "\(year)/\(month)/\(day)"
        
        
        let usersReference = ref.child("Records").child(ref.childByAutoId().key)
        let post = ["time": "平均呼吸時間為 2 秒/次", "Date": today]
        usersReference.updateChildValues(post)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func playSound(soundname: String) {
        guard let url = Bundle.main.url(forResource: soundname, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer.init(contentsOf: url)
            player?.play()
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
}
