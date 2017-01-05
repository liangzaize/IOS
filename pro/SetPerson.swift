//
//  SetPerson.swift
//  pro
//
//  Created by 胡康泽 on 2016/11/21.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit

class SetPerson: UIViewController{
    
    @IBOutlet weak var gold: UILabel!
    @IBOutlet weak var silver: UILabel!
    @IBOutlet weak var copper: UILabel!
    @IBOutlet weak var tupian: UIImageView!
    @IBOutlet weak var touxiang: UILabel!
    
    @IBAction func sign(_ sender: Any) {
        //nj
    }
    @IBOutlet weak var level: UILabel!

    @IBAction func zhuToSet(segue: UIStoryboardSegue){
        if segue.identifier == "zhuToSet"{
            let data = segue.source as! Zhu
            self.touxiang.text = data.account.text
            self.level.text = data.level
            self.level.text = "懵懂菜鸟"
        }
    }
    
    var level_1: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if animated == true {
//            modeView.back()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
