//
//  FirstViewController.swift
//  pro
//
//  Created by 胡康泽 on 2016/10/27.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DeviceController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var Wri: UIScrollView!
    @IBOutlet weak var leftTable: UITableView!
    @IBOutlet weak var midTable: UITableView!
    @IBOutlet weak var rightTable: UITableView!
    @IBOutlet weak var Graphics: UIButton!
    @IBOutlet weak var CPU: UIButton!
    @IBOutlet weak var Motherboard: UIButton!
    @IBOutlet weak var RAM: UIButton!
    @IBOutlet weak var harddisk: UIButton!
    @IBOutlet weak var heatsink: UIButton!
    @IBOutlet weak var Chassis: UIButton!
    @IBOutlet weak var mouse: UIButton!
    @IBOutlet weak var keyboard: UIButton!
    @IBOutlet weak var Speakers: UIButton!
    @IBOutlet weak var powersupply: UIButton!

    @IBAction func Graphics(_ sender: AnyObject) {
        cancel(0)
        Wri.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        locat = 0
        Mid = false
        reload()
    }
    @IBAction func CPU(_ sender: AnyObject) {
        button(1)
    }
    @IBAction func Motherboard(_ sender: AnyObject) {
        button(2)
    }
    @IBAction func RAM(_ sender: AnyObject) {
        button(3)
    }
    @IBAction func harddisk(_ sender: AnyObject) {
        button(4)
    }
    @IBAction func heatsink(_ sender: AnyObject) {
        button(5)
    }
    @IBAction func Chassis(_ sender: AnyObject) {
        button(6)
    }
    @IBAction func mouse(_ sender: AnyObject) {
        button(7)
    }
    @IBAction func keyboard(_ sender: AnyObject) {
        button(8)
    }
    @IBAction func Speakers(_ sender: AnyObject) {
        button(9)
    }
    @IBAction func powersupply(_ sender: AnyObject) {
        cancel(10)
        Wri.setContentOffset(CGPoint(x: 750, y: 0), animated: true)
        locat = 10
        Finally = true
        reload()
    }
    
    var locat = 0
    var Mid = false
    var Finally = false
    var Save: String!
    var arrayNames: Array<String> = []
    var Dict = [0: "GTX-1080",
                1: "b",
                2: "c",
                3: "d",
                4: "e",
                5: "f",
                6: "g",
                7: "h",
                8: "i",
                9: "j",
                10: "k"]
    let selfSignedHosts = ["40.74.84.240"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Wri.delegate = self
        Graphics.isSelected = true
        leftTable.tableFooterView = UIView()
        midTable.tableFooterView = UIView()
        rightTable.tableFooterView = UIView()
        //会话管理默认实例
        let manager = Alamofire.SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            
            //服务器认证
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
                && self.selfSignedHosts.contains(challenge.protectionSpace.host) {
                //如果现在的验证方法是服务器认证且host和保存的一样
                let credential = URLCredential(trust:challenge.protectionSpace.serverTrust!)
                return (.useCredential, credential)
            }
                
                //客户端认证
            else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                //客户端认证
                let identityAndTrust: IdentityAndTrust = self.extractIdentity()
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                return (.useCredential, urlCredential);
            }
                
            else {
                //其它情况，不认证
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //获取客户端证书相关信息
    func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: "tomcat", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "hukangze"] //客户端证书密码
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems:CFArray = items as CFArray!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentity:SecIdentity = identityPointer as! SecIdentity!;
                print("\(identityPointer)  :::: \(secIdentity)")
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"];
                let trust:SecTrust = trustPointer as! SecTrust;
                print("\(trustPointer)  :::: \(trust)")
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"];
                identityAndTrust = IdentityAndTrust(identityRef: secIdentity,
                                                    trust:       trust,
                                                    certArray:   chainPointer!);
            }
        }
        return identityAndTrust;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cancel(locat)
        switch tableView {
        case leftTable:
            cell = tableView.dequeueReusableCell(withIdentifier: "left", for: indexPath)
            let label = cell.viewWithTag(1) as! UILabel
            if locat == 0 {
                label.text = Dict[locat]
            } else {
                label.text = Dict[locat - 1]
            }
            return cell
        case midTable:
            cell = tableView.dequeueReusableCell(withIdentifier: "mid", for: indexPath)
            let label = cell.viewWithTag(1) as! UILabel
            if locat == 0 {
                label.text = Dict[locat + 1]
            } else if locat == 10 {
                label.text = Dict[locat - 1]
            }
            else {
                label.text = Dict[locat]
            }
            return cell
        case rightTable:
            cell = tableView.dequeueReusableCell(withIdentifier: "right", for: indexPath)
            let label = cell.viewWithTag(1) as! UILabel
            if locat == 10 {
                label.text = Dict[locat]
            } else {
            label.text = Dict[locat + 1]
            }
            return cell
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell! = tableView.cellForRow(at: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        Save = label.text!
        let send: Dictionary = ["Type": Save] as [String : Any]
        //发送硬件的具体型号
        Alamofire.request("https://40.74.84.240:8080", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.arrayNames =  json["Port"].arrayValue.map({$0.stringValue})
                    self.performSegue(withIdentifier: "gotodetail", sender: nil)
                    tableView.deselectRow(at: indexPath, animated: true)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotodetail"{
            let dest: DetailController = segue.destination as! DetailController
            dest.get = Save
            dest.get1 = self.arrayNames
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == Wri
        {
            search.resignFirstResponder()
            reload()
            switch scrollView.contentOffset.x {
            case 0:
                if locat == 0{
                    Wri.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    Mid = false
                }
                else {
                    locat -= 1
                    if locat == 0 {
                        Wri.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                        Mid = false
                    } else {
                    Wri.setContentOffset(CGPoint(x: 375, y: 0), animated: false)
                    }
                }
                break
            case 375:
                Wri.setContentOffset(CGPoint(x: 375, y: 0), animated: true)
                if !Mid {
                    if Finally{
                        locat -= 1
                        Finally = false
                    } else {
                        locat += 1
                    }
                    Mid = true
                }
                break
            case 750:
                if locat == 10 {
                    Wri.setContentOffset(CGPoint(x: 750, y: 0), animated: true)
                } else {
                locat += 1
                if locat == 10 {
                    Wri.setContentOffset(CGPoint(x: 750, y: 0), animated: true)
                    Finally = true
                    Mid = false
                } else {
                Wri.setContentOffset(CGPoint(x: 375, y: 0), animated: false)
                }
                }
                break
            default:
                return
            }
        }
        else {
            search.resignFirstResponder()
        }
    }
    
    func cancel(_ count: Int) {
        Graphics.isSelected = false
        CPU.isSelected = false
        Motherboard.isSelected = false
        RAM.isSelected = false
        harddisk.isSelected = false
        heatsink.isSelected = false
        Chassis.isSelected = false
        mouse.isSelected = false
        keyboard.isSelected = false
        Speakers.isSelected = false
        powersupply.isSelected = false
        
        switch count {
        case 0:
            Graphics.isSelected = true
            break
        case 1:
            CPU.isSelected = true
            break
        case 2:
            Motherboard.isSelected = true
            break
        case 3:
            RAM.isSelected = true
            break
        case 4:
            harddisk.isSelected = true
            break
        case 5:
            heatsink.isSelected = true
            break
        case 6:
            Chassis.isSelected = true
            break
        case 7:
            mouse.isSelected = true
            break
        case 8:
            keyboard.isSelected = true
            break
        case 9:
            Speakers.isSelected = true
            break
        case 10:
            powersupply.isSelected = true
            break
        default:
            return
        }
    }
    
    func reload() {
        leftTable.reloadData()
        midTable.reloadData()
        rightTable.reloadData()
    }
    
    func button(_ math: Int){
        cancel(math)
        Wri.setContentOffset(CGPoint(x: 375, y: 0), animated: true)
        locat = math
        reload()
    }
}

