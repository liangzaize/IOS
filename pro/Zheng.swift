//
//  Zheng.swift
//  pro
//
//  Created by 胡康泽 on 18/01/2017.
//  Copyright © 2017 胡康泽. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin
import Alamofire
import SwiftyJSON

class Zheng: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var lookId: UILabel!
    @IBOutlet weak var h: UILabel!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var viewheight: UIView!
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var photo: String? = nil
    var get: String!
    var get1: String!
    var number = 10
    var head = " "
    var Id: Array<String> = [""]
    var loadMoreEnable = true
    var loadMoreView: UIView?
    var refreshControl = UIRefreshControl()
    var Text: Array<String> = [""]
    var Name: Array<String> = [""]
    var Level: Array<String> = [""]
    var loading: UIImageView!
    var myButton: UIButton!
    var fullScreenSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenSize = UIScreen.main.bounds.size
        loading = UIImageView(frame: CGRect(x: 0, y: viewheight.frame.height, width: self.view.frame.width, height: self.view.frame.height - viewheight.frame.height))
        loading.contentMode = UIViewContentMode.scaleAspectFit
        loading.loadGif(name: "加载中")
        self.view.addSubview(loading)
        connect(10)
        refreshControl.addTarget(self, action: #selector(Cover.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        tablev.addSubview(refreshControl)
        self.setupInfiniteScrollingView()
        tablev.tableFooterView = self.loadMoreView
        tablev.separatorStyle = .none
        tablev.estimatedRowHeight = 40
        tablev.rowHeight = UITableViewAutomaticDimension
        myButton = UIButton(
            frame: CGRect(x: fullScreenSize.width * 0.9, y: fullScreenSize.height, width: 30, height: 30))
        myButton.setImage(UIImage(named: "pencil"), for: UIControlState.normal)
        // 按鈕是否可以使用
        myButton.isEnabled = true
        myButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        self.view.addSubview(myButton)
        h.adjustsFontSizeToFitWidth = true
    }
    
    func tapped(){
        let cookieJar = HTTPCookieStorage.shared.cookies(
            for: URL(string:"https://" + url.URLNAME + ":8443")!)
        if cookieJar?.count == 0 {
            let alertController = UIAlertController(title: "请先登录",
                                                    message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        } else {
        self.performSegue(withIdentifier: "reply", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reply"{
            let dest: Reply = segue.destination as! Reply
            dest.titl = self.head
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Text.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstcell", for: indexPath)
        let midview = cell.viewWithTag(6)
        let cou = cell.viewWithTag(7) as! UILabel
        midview?.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 223/255, alpha: 0.5).cgColor
        midview?.layer.borderWidth = 1
        if indexPath.row == 0 {
            cou.text = "楼主"
        } else {
            cou.text = "\(indexPath.row)楼"
        }
        let picture = cell.viewWithTag(2) as! UIImageView
        let name = cell.viewWithTag(3) as! UILabel
        name.adjustsFontSizeToFitWidth = true
        let level = cell.viewWithTag(4) as! UILabel
        let textview = cell.viewWithTag(5) as! UITextView
        let iid = cell.viewWithTag(8) as!UILabel
        textview.isScrollEnabled = false
        textview.text = self.Text[indexPath.row]
        name.text = self.Name[indexPath.row]
        level.text = self.Level[indexPath.row]
        iid.text = self.Id[indexPath.row]
        if let imageURL = URL(string:"https://" + url.URLNAME + ":8443/pict/" + self.Id[indexPath.row] + ".jpg") {
            DispatchQueue.global().async {
                Alamofire.request(imageURL, method: .get).responseData { response in
                    guard let data = response.result.value else {
                        picture.image = UIImage(named: "error") //未加载到海报显示默认的“暂无图片”
                        return
                    }
                    picture.image = UIImage(data: data)
                }
            }
        }

        if indexPath.row % 2 == 1{
            cell.backgroundColor = UIColor(red: 244/255, green: 243/255, blue: 155/255, alpha: 0.5)
        } else {
            cell.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 220/255, alpha: 0.5)
        }
        return cell
    }
    
    func refreshData() {
        refreshControl.beginRefreshing()
        connect(10)
    }
    
    //上拉刷新视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect(x: 0, y: tablev.contentSize.height,
                                                 width: tablev.bounds.size.width, height: 60))
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0{
            myButton.frame = CGRect(x: myButton.frame.origin.x,y: fullScreenSize.height * 0.93,width: myButton.frame.size.width,height: myButton.frame.size.height)
        } else {
            myButton.frame = CGRect(x: myButton.frame.origin.x,y: fullScreenSize.height,width: myButton.frame.size.width,height: myButton.frame.size.height)
        }
    }
    
    func connect(_ count: Int){
        let send: Dictionary = ["Type": get, "Fa": get1, "Count": number] as [String : Any]
            Alamofire.request("https://" + url.URLNAME + ":8443/maintalk", method: .post, parameters: send, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        switch self.number {
                        case 10:
                            self.head = json["Type"].stringValue
                            self.Name = json["Body"].arrayValue.map({$0.stringValue})
                            self.Text = json["Head"].arrayValue.map({$0.stringValue})
                            self.Level = json["Image"].arrayValue.map({$0.stringValue})
                            self.Id = json["Posttime"].arrayValue.map({$0.stringValue})
                            if json["Port"].boolValue != false{
                                self.loadMoreEnable = true
                            } else {
                                self.tablev.tableFooterView = UIView()
                            }
                            self.loading.isHidden = true
                            self.tablev.reloadData()
                            self.refreshControl.endRefreshing()
                            self.h.text = self.head
                        default :
                            if json["Port"].boolValue != false{
                                self.loadMoreEnable = true
                            } else {
                                self.tablev.tableFooterView = UIView()
                            }
                            self.Name = json["Body"].arrayValue.map({$0.stringValue})
                            self.Text = json["Head"].arrayValue.map({$0.stringValue})
                            self.Level = json["Image"].arrayValue.map({$0.stringValue})
                            self.Id = json["Posttime"].arrayValue.map({$0.stringValue})
                            self.tablev.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                    case .failure(let error):
                        print(error)
                        }
                }
    }
}
