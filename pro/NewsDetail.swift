//
//  Newsdetail.swift
//  pro
//
//  Created by 胡康泽 on 2016/11/21.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class NewsDetail: UIViewController {
 
    @IBOutlet weak var news: UIWebView!
    var get: String!
    var get1: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let parameters: Parameters = ["Type": get,"Fa": get1]
        Alamofire.request("https://192.168.0.106:8443/newsdata", parameters: parameters).responseString {
            response in
            self.news.loadHTMLString(response.result.value!, baseURL: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
