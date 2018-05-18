//
//  History_table.swift
//  QiGong
//
//  Created by mac on 11/1/2018.
//  Copyright © 2018 ncku. All rights reserved.
//

import UIKit
import Firebase

class History_table: UITableViewController {

    let cellId = "cellId"
    var records = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetch()
    }
    
    func fetch() {
        Database.database().reference().child("Records").observe(.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let record = Record()
                    let time = value["time"] as? String ?? "time not found"
                    let date = value["Date"] as? String ?? "date not found"
                    record.Time = time
                    record.Date = date
                    self.records.append(record)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let record = records[indexPath.row]
        
        cell.textLabel?.text = record.Time
        cell.detailTextLabel?.text = record.Date
        
        return cell
    }

}

class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Record: NSObject {
    var Date: String?
    var Time: String?
}

