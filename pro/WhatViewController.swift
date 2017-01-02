//
//  WhatViewController.swift
//  pro
//
//  Created by 胡康泽 on 2016/10/29.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit

class WhatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var q: UINavigationItem!
    var get: String?
    var get1: [[String]]?
    var titlehead: String?
    var get2: [[String]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        q.title = get        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return get1![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "data", for: indexPath)
//        cell.isUserInteractionEnabled = false
        let label = cell.viewWithTag(1) as! UILabel
        let label1 = cell.viewWithTag(2) as! UILabel
        label.text = get1![indexPath.section][indexPath.row]
        label1.text = get2![indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell! = tableView.cellForRow(at: indexPath)
        let label = cell.viewWithTag(2) as! UILabel
        let Save = label.text!
        let alertController = UIAlertController(title: "详细信息",
                                                message: Save, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            titlehead = "显卡核心"
        case 1:
            titlehead = "显卡频率"
        case 2:
            titlehead = "显存规格"
        case 3:
            titlehead = "显卡散热"
        case 4:
            titlehead = "显卡接口"
        case 5:
            titlehead = "物理特性"
        case 6:
            titlehead = "其它参数"
        case 7:
            titlehead = "保修信息"
        default:
            break
        }
        return titlehead
    }
}
