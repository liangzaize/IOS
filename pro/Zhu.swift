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


class Zhu: UIViewController, UITabBarDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var tab: UITabBar!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    
    var quit: Bool = false
    var money: Int = 0
    var photo: String? = nil
    var level: String = ""
    
    @IBOutlet weak var hint: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.loadGif(name: "登录界面")
        account.delegate = self
        password.delegate = self
        tab.delegate = self
        account.returnKeyType = UIReturnKeyType.done
        password.returnKeyType = UIReturnKeyType.done
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(img: AnyObject)
    {
        account.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if quit == false {
        self.performSegue(withIdentifier: "zhuToSet", sender: nil)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let pattern = "^[a-z0-9A-Z\\u4e00-\\u9fa5]*$"
        let matcher = MyRegex(pattern)
            
        switch item.tag {
        case 1:
            if (account.text?.characters.count)! < 6 || (account.text?.characters.count)! > 12{
                hint.text = "用户名字太短或太长，请确保在6~12个字符的范围"
            } else if matcher.match(input: account.text!) == false{
                hint.text = "非法用户名，请使用汉字、英文字母、数字或下划线"
            } else if (password.text?.characters.count)! < 6 {
                hint.text = "密码过弱，至少为6位字符"
            }
            else {
                sendtheala("https://" + url.URLNAME + ":8443/sign")
            }
            break
        case 2:
            if (account.text?.characters.count)! < 6 || (account.text?.characters.count)! > 12
            || matcher.match(input: account.text!) == false {
                hint.text = "用户名/密码错误"
            } else {
                sendtheala("https://" + url.URLNAME + ":8443/login")
            }
            break
        case 3:
            quit = true
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
                        self.level = "懵懂菜鸟"
                        self.money = 0
                        self.photo = "null"
                        self.dismiss(animated: true, completion: nil)
                    } else if json["Port1"].boolValue == true {
                        self.photo = json["Type"].stringValue
                        self.level = json["Fa"].stringValue
                        self.money = json["Count"].intValue
                        self.dismiss(animated: true, completion: nil)
                    } else if json["Port"].boolValue == false && json["Port1"].boolValue == false{
                        let alertController = UIAlertController(title: "失败",
                                                                message: json["Type"].stringValue, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        return true;
    }
    
    
}

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                         options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}
