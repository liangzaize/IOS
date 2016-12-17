//
//  SetPerson.swift
//  pro
//
//  Created by 胡康泽 on 2016/11/21.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit

class SetPerson: UIViewController, ModeViewControlDelegate{
    
    @IBOutlet weak var gold: UILabel!
    @IBOutlet weak var silver: UILabel!
    @IBOutlet weak var copper: UILabel!
    @IBOutlet weak var tupian: UIImageView!
    @IBOutlet weak var touxiang: UILabel!
    
    @IBAction func sign(_ sender: Any) {
        //
    }
    @IBOutlet weak var level: UILabel!
    
    var level_1: String = " "
    var modeView = Zhu()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modeView.delegate_1 = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(animated)
        if animated == true {
            modeView.back()
        }
    }
    
    func changeLabel(newString: String){
        level_1 = newString
        print(level_1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
