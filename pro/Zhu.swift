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
            sendtheala("https://localhost:8443/sign")
            break
        case 2:
            sendtheala("https://localhost:8443/sign")
            break
        case 3:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func sendtheala(_ URL: String){
        let send: Dictionary = ["Type": account.text!, "Fa": password.text!] as [String : Any]
        
        //发送账号密码
        Alamofire.request(URL, method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["Port"].boolValue == true {
                        self.dismiss(animated: true, completion: nil)
                        self.baa = self.account.text
                        self.delegate_1?.changeLabel(newString: self.baa!)

                    } else {
                        let alertController = UIAlertController(title: "注册失败",
                                                                message: "用户名已存在", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)

                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}

protocol ModeViewControlDelegate{
    func changeLabel(newString: String)
}
