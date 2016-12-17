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
    var detail: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let send: Dictionary = ["Title": get, "Content": get1] as [String : Any]
        //给服务器发送请求，把信息发送回来
        Alamofire.request("https://40.74.84.240:8080/newsdata", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.detail = json["Port"].arrayValue.map({$0.stringValue})
                    self.news.loadHTMLString(self.detail[0],baseURL:nil)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
