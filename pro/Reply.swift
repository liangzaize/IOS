//
//  Reply.swift
//  pro
//
//  Created by 胡康泽 on 14/03/2017.
//  Copyright © 2017 胡康泽. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Reply: UIViewController, UITextViewDelegate{
    @IBOutlet weak var s: NSLayoutConstraint!
    @IBOutlet weak var counts: UILabel!
    @IBOutlet weak var text: UITextView!
    @IBAction func send(_ sender: Any) {
        text.resignFirstResponder()
        connect()
    }
    @IBAction func cancel(_ sender: Any) {
        text.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    var placeholderLabel : UILabel!
    var titl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        text.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(Reply.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        placeholderLabel = UILabel()
        placeholderLabel.text = "内容"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (text.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        text.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 0, y: (text.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !text.text.isEmpty

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func connect(){
        let send: Dictionary = ["Type": text.text!,"Fa": titl] as [String : Any]
        
        let alertController = UIAlertController(title: "发送中......",
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        
        Alamofire.request("https://" + url.URLNAME + ":8443/reply", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let a = json["Port"].boolValue
                    if a == true {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                        let alertController = UIAlertController(title: "发送失败",
                                                                message: nil, preferredStyle: .alert)
                        //显示提示框
                        self.present(alertController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }

    
    func keyboardWillShow(notification : Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            self.s.constant = intersection.height
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve), animations: {
                            _ in
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        let n = textView.text.characters.count
        counts.text = "\(n)"
        if n >= 200 && n <= 400{
            counts.textColor = .orange
        } else if n > 400 {
            counts.textColor = .red
        }else {
            counts.textColor = .black
        }
    }
}
