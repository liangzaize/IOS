//
//  Cover.swift
//  pro
//
//  Created by 胡康泽 on 2016/11/21.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Cover: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBAction func tun(_ sender: Any) {
        if a.title == "未登录"{
            let alertController = UIAlertController(title: "请先登录",
                                                    message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        } else {
            self.performSegue(withIdentifier: "send", sender: self)
        }
    }
    
    @IBOutlet weak var a: UINavigationItem!
    
    var count1 = 10
    @IBOutlet weak var tableview: UITableView!
    var TitleShow: Array<String> = [""]
    var Name: Array<String> = [""]
    var Number: Array<Int> = [0]
    var refreshControl = UIRefreshControl()
    var loadMoreEnable = true
    var loadMoreView: UIView?
    var timeStamp: Int64?
    var timeu: Array<Int64> = [0]
    var Save: String?
    var Save1: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connect(incount: 10)
        refreshControl.addTarget(self, action: #selector(Cover.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        tableview.addSubview(refreshControl)
        self.setupInfiniteScrollingView()
        tableview.tableFooterView = self.loadMoreView
        a.title = "未登录"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "talk", for: indexPath)
        let lebel = cell.viewWithTag(1) as! UILabel
        let lebel1 = cell.viewWithTag(2) as! UILabel
        let lebel2 = cell.viewWithTag(3) as! UILabel
        let lebel3 = cell.viewWithTag(4) as! UILabel
        let lebel4 = cell.viewWithTag(5) as! UILabel
        lebel.text = self.TitleShow[indexPath.row]
        lebel1.text = self.Name[indexPath.row]
        lebel2.text = "\(self.Number[indexPath.row])"
        let t = timeStamp! - self.timeu[indexPath.row]
        if self.timeu[indexPath.row] == 0 {
            lebel3.text = ""
        } else if t < 60 {
            lebel3.text = "刚才"
        } else if t < 3600 {
            lebel3.text = "\(t / 60)分钟前"
        } else if t < 86400 {
            lebel3.text = "\(t / 3600)小时前"
        } else {
            lebel3.text = "\(t / 86400)天前"
        }
        lebel4.text = "\(self.timeu[indexPath.row])"
        if (loadMoreEnable && indexPath.row == TitleShow.count - 1) {
            connect(incount: TitleShow.count + 11)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell! = tableView.cellForRow(at: indexPath)
        let label = cell.viewWithTag(5) as! UILabel
        let label1 = cell.viewWithTag(2) as! UILabel
        Save = label.text
        Save1 = label1.text
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "gotozheng", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotozheng"{
            let dest: Zheng = segue.destination as! Zheng
            dest.get = Save
            dest.get1 = Save1
        }
    }
    
    //上拉刷新视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect(x: 0, y: tableview.contentSize.height,
                                                 width: tableview.bounds.size.width, height: 60))
        self.loadMoreView!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.loadMoreView!.backgroundColor = UIColor.white
        
        //添加中间的环形进度条
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityViewIndicator.color = UIColor.darkGray
        let indicatorX = self.loadMoreView!.frame.size.width/2-activityViewIndicator.frame.width/2
        let indicatorY = self.loadMoreView!.frame.size.height/2-activityViewIndicator.frame.height/2
        activityViewIndicator.frame = CGRect(x: indicatorX, y: indicatorY,
                                             width: activityViewIndicator.frame.width,
                                             height: activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.loadMoreView!.addSubview(activityViewIndicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    func refreshData() {
        refreshControl.beginRefreshing()
        connect(incount: 10)
    }
    
    func connect(incount count1: Int){
        let send: Dictionary = ["Type": "hukangze", "Count": count1] as [String : Any]
        loadMoreEnable = false
        let now = NSDate()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        timeStamp = Int64(timeInterval)
        //给服务器发送请求，把信息发送回来
        Alamofire.request("https://" + url.URLNAME + ":8443/talk", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    switch count1 {
                    case 10:
                        self.TitleShow = json["Head"].arrayValue.map({$0.stringValue})
                        self.Name = json["Body"].arrayValue.map({$0.stringValue})
                        self.Number = json["Image"].arrayValue.map({$0.intValue})
                        self.timeu = json["Posttime"].arrayValue.map({$0.int64Value})
                        if !json["Type"].stringValue.isEmpty {
                            self.a.title = json["Type"].stringValue
                        }
                        if json["Port"].boolValue != false{
                            self.loadMoreEnable = true
                        } else {
                            self.tableview.tableFooterView = UIView()
                        }
                        self.tableview.reloadData()
                        self.refreshControl.endRefreshing()
                    default :
                        if json["c"].boolValue != false{
                            self.loadMoreEnable = true
                        } else {
                            self.tableview.tableFooterView = UIView()
                        }
                        self.TitleShow += json["Head"].arrayValue.map({$0.stringValue})
                        self.Name += json["Body"].arrayValue.map({$0.stringValue})
                        self.Number += json["Image"].arrayValue.map({$0.intValue})
                        self.timeu = json["Posttime"].arrayValue.map({$0.int64Value})
                        if !json["Type"].stringValue.isEmpty {
                            self.a.title = json["Type"].stringValue
                        }

                        self.tableview.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}
