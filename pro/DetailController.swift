//
//  DetailController.swift
//  pro
//
//  Created by 胡康泽 on 2016/10/27.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class DetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate {
    
    @IBOutlet weak var s: UINavigationItem!
    @IBOutlet weak var what: UITableView!
    
    //get用作判定是显卡类还是CPU类还是其他种类
    var get: String?
    var get1: Array<String>?
    var get2: Array<String>?
    var Save: String!
    var arrayNames: Array<String> = []
    var arrayNames_1: Array<String> = []
    var numb: Array<Int> = []
    var wenzi = ["显存频率","接口类型","显卡类型","保修政策"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        s.title = get
        what.tableFooterView = UIView()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return get1!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "type", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = get1![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell! = tableView.cellForRow(at: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        Save = label.text!
        let send: Dictionary = ["Type": get!, "Fa": Save] as [String : Any]
        
        //发送型号+厂商，就可以定位具体的产品
        Alamofire.request("https://192.168.0.106:8443/hardware", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.arrayNames = json["Port"].arrayValue.map({$0.stringValue})
                    self.arrayNames_1 = json["Type"].arrayValue.map({$0.stringValue})
                    self.performSegue(withIdentifier: "into", sender: nil)
                    tableView.deselectRow(at: indexPath, animated: true)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var num = 0, num1 = 0, num2 = 0
        var se = 0, se1 = 0, se2 = 0
        var ss = [[String]]()
        var s = [String]()
        var nn = [[String]]()
        var n = [String]()
        let length = arrayNames.count
        
        if segue.identifier == "into"{
            let dest: WhatViewController = segue.destination as! WhatViewController
            dest.get = Save
            while num1 < wenzi.count{
            while arrayNames[num] != wenzi[num1] {
                s.insert(arrayNames[num], at: num2)
                num += 1
                num2 += 1
            }
            ss.append(s)
                numb.append(s.count)
            s.removeAll()
                num2 = 0
                num1 += 1
            }
            while num < length {
                s.insert(arrayNames[num], at: num2)
                num2 += 1
                num += 1
            }
            numb.append(s.count)
            ss.append(s)
            dest.get1 = ss
            
            while se < num {
            while se2 < numb[se1]{
                n.insert(arrayNames_1[se], at: se2)
                se2 += 1
                se += 1
            }
                se2 = 0
                se1 += 1
            nn.append(n)
            n.removeAll()
            }
            dest.get2 = nn
            numb.removeAll()
        }
    }
}

struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}
