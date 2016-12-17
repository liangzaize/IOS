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
    var a = [
        ["芯片厂商", "显卡芯片", "显示芯片系列", "制作工艺", "核心代号"],
        ["核心频率", "显存频率"],
        ["显存类型", "显存容量", "显存位宽", "最大分辨率"],
        ["散热方式"],
        ["接口类型", "I/O接口", "电源接口"],
        ["3D API", "流处理单元"],
        ["显卡类型", "支持HDCP", "供电模式", "最大功耗", "建议电源", "上市日期"],
        ["保修政策", "质保时间", "质保备注", "客服电话"]
    ]
    
    
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
        return a[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "data", for: indexPath)
        cell.isUserInteractionEnabled = false
        let label = cell.viewWithTag(1) as! UILabel
        let label1 = cell.viewWithTag(2) as! UILabel
        label.text = a[indexPath.section][indexPath.row]
        label1.text = get1?[indexPath.section][indexPath.row]
        return cell
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
