//
//  Zhu.swift
//  pro
//
//  Created by 胡康泽 on 2016/11/23.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin
import Alamofire
import SwiftyJSON


class Zhu: UIViewController, UITabBarDelegate{
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var tab: UITabBar!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    
    var arrayNames: Array<String> = []
    var delegate_1: ModeViewControlDelegate?
    var baa: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.loadGif(name: "登录界面")
        tab.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            sendtheala("https://40.74.84.240:8080/id/up")
            break
        case 2:
            sendtheala("https://40.74.84.240:8080/id/down")
            break
        case 3:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func sendtheala(_ URL: String){
        let send: Dictionary = ["Account": account.text!, "Password": password.text!] as [String : Any]
        
        //发送账号密码
        Alamofire.request(URL, method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.arrayNames =  json["Port"].arrayValue.map({$0.stringValue})
                    self.back()
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func back (){
        delegate_1?.changeLabel(newString: arrayNames[0])
    }
}

protocol ModeViewControlDelegate{
    func changeLabel(newString: String)
}
