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
    var count: Int = 10
    var refreshControl = UIRefreshControl()
    var save: String!
    var save1: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        uitableview.tableFooterView = UIView()
        connect(incount: count)
        refreshControl.addTarget(self, action: #selector(TalkViewController.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        uitableview.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        refreshControl.beginRefreshing()
        connect(incount: count + 10)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlename.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath)
        let lebel = cell.viewWithTag(1) as! UILabel
        let lebel1 = cell.viewWithTag(2) as! UILabel
        _ = cell.viewWithTag(3) as! UIImageView
        lebel.text = self.titlename[indexPath.row]
        lebel1.text = self.content[indexPath.row]
        return cell
    }
    
    func connect(incount count1: Int){
    let send: Dictionary = ["Type": "hukangze", "Count": count1] as [String : Any]
        //给服务器发送请求，把信息发送回来
        Alamofire.request("https://40.74.84.240:8080/getnews", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.titlename = json["Title"].arrayValue.map({$0.stringValue})
                    self.content = json["Content"].arrayValue.map({$0.stringValue})
                    self.picture = json["Picture"].arrayValue.map({$0.stringValue})
                    self.uitableview.reloadData()
                    self.refreshControl.endRefreshing()
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

