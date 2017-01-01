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
    var Save: String!
    var arrayNames: Array<String> = []
    var arrayNames_1: Array<String> = []
    
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
        Alamofire.request("https://localhost:8443/hardware", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.arrayNames = json["Port"].arrayValue.map({$0.stringValue})
                    self.arrayNames_1 = json["Type"].arrayValue.map({$0.stringValue})
                    print(self.arrayNames)
                    print(self.arrayNames_1)
                    self.performSegue(withIdentifier: "into", sender: nil)
                    tableView.deselectRow(at: indexPath, animated: true)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "into"{
            let dest: WhatViewController = segue.destination as! WhatViewController
            dest.get = Save
            
            var ss = [[String]]()
            ss.append([])
//            let ss = [
//            [self.arrayNames[0],self.arrayNames[1],self.arrayNames[2],self.arrayNames[3],self.arrayNames[4]],
//            [self.arrayNames[5],self.arrayNames[6]],
//            [self.arrayNames[7],self.arrayNames[8],self.arrayNames[9],self.arrayNames[10]],
//            [self.arrayNames[11]],
//            [self.arrayNames[12],self.arrayNames[13],self.arrayNames[14]],
//            [self.arrayNames[15],self.arrayNames[16]],
//            [self.arrayNames[17],self.arrayNames[18],self.arrayNames[19],self.arrayNames[20],self.arrayNames[21],self.arrayNames[22]],
//            [self.arrayNames[23],self.arrayNames[24],self.arrayNames[25],self.arrayNames[26]]
//            ]
            //dest.get1 = ss
        }
    }
}

struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}
