//
//  SecondViewController.swift
//  pro
//
//  Created by 胡康泽 on 2016/10/27.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TalkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var uitableview: UITableView!
    
    var titlename: Array<String> = ["......"]
    var content: Array<String> = ["......"]
    var picture: Array<String> = [""]
    var loadMoreView: UIView?
    var count: Int = 10
    var refreshControl = UIRefreshControl()
    var save: String!
    var save1: String!
    var loadMoreEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        connect(incount: count)
        refreshControl.addTarget(self, action: #selector(TalkViewController.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        uitableview.addSubview(refreshControl)
        self.setupInfiniteScrollingView()
        uitableview.tableFooterView = self.loadMoreView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //上拉刷新视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect(x: 0, y: uitableview.contentSize.height,
                                                 width: uitableview.bounds.size.width, height: 60))
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
    
    func refreshData() {
        refreshControl.beginRefreshing()
        connect(incount: 10)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlename.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath)
        let lebel = cell.viewWithTag(1) as! UILabel
        let lebel1 = cell.viewWithTag(2) as! UILabel
        let pict = cell.viewWithTag(3) as! UIImageView
        lebel.text = self.titlename[indexPath.row]
        lebel1.text = self.content[indexPath.row]
        if let imageURL = URL(string:"https://" + url.URLNAME + ":8443/news" + self.picture[indexPath.row]) {
            DispatchQueue.global().async {
                Alamofire.request(imageURL, method: .get).responseData { response in
                    guard let data = response.result.value else {
                        pict.image = UIImage(named: "error") //未加载到海报显示默认的“暂无图片”
                        return
                    }
                    pict.image = UIImage(data: data)
                }
            }
        }
        if (loadMoreEnable && indexPath.row == titlename.count - 1) {
            connect(incount: titlename.count + 11)
        }
        return cell
    }
    
    func connect(incount count1: Int){
    let send: Dictionary = ["Type": "hukangze", "Count": count1] as [String : Any]
        loadMoreEnable = false
        //给服务器发送请求，把信息发送回来
        Alamofire.request("https://" + url.URLNAME + ":8443/news", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    switch count1 {
                    case 10:
                        self.titlename = json["Head"].arrayValue.map({$0.stringValue})
                        self.content = json["Body"].arrayValue.map({$0.stringValue})
                        self.picture = json["Image"].arrayValue.map({$0.stringValue})
                        if json["Port"].boolValue != false{
                            self.loadMoreEnable = true
                        } else {
                            self.uitableview.tableFooterView = UIView()
                        }
                        self.uitableview.reloadData()
                        self.refreshControl.endRefreshing()
                    default :
                        if json["Port"].boolValue != false{
                            self.loadMoreEnable = true
                        } else {
                            self.uitableview.tableFooterView = UIView()
                        }
                        self.titlename += json["Head"].arrayValue.map({$0.stringValue})
                        self.content += json["Body"].arrayValue.map({$0.stringValue})
                        self.picture += json["Image"].arrayValue.map({$0.stringValue})
                        self.uitableview.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell! = tableView.cellForRow(at: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        let label1 = cell.viewWithTag(2) as! UILabel
        save = label.text!
        save1 = label1.text!
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "newsdata", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsdata"{
            let dest: NewsDetail = segue.destination as! NewsDetail
            dest.get = save
            dest.get1 = save1
        }
    }
}

