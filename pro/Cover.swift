//
//  Cover.swift
//  pro
//
//  Created by 胡康泽 on 2016/11/21.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit

class Cover: UIViewController {
    
    @IBOutlet weak var a: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        a.title = "未登录"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
