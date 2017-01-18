//
//  Send.swift
//  pro
//
//  Created by 胡康泽 on 14/01/2017.
//  Copyright © 2017 胡康泽. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Send: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    @IBAction func send(_ sender: Any) {
        titlewrite.resignFirstResponder()
        text.resignFirstResponder()
        connect()
    }
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBAction func cancel(_ sender: Any) {
        titlewrite.resignFirstResponder()
        text.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var arriternumber: UILabel!
    @IBOutlet weak var titlenumber: UILabel!
    @IBOutlet weak var titlewrite: UITextField!
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.delegate = self
        let myColor : UIColor = UIColor.gray
        titlewrite.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(Send.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        titlewrite.addTarget(self, action: #selector(Send.textwillchange), for: UIControlEvents.editingChanged)
        titlewrite.returnKeyType = UIReturnKeyType.done
        text.layer.borderWidth = 0.4
        text.layer.borderColor = myColor.cgColor
        placeholderLabel = UILabel()
        placeholderLabel.text = "内容"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (text.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        text.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: titlewrite.frame.origin.x, y: (text.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !text.text.isEmpty
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func keyboardWillShow(notification : Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            self.bottom.constant = intersection.height
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve), animations: {
                            _ in
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func connect(){
        let send: Dictionary = ["Type": titlewrite.text!, "Fa": text.text!] as [String : Any]
        
        let alertController = UIAlertController(title: "保存成功!",
                                                message: nil, preferredStyle: .alert)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
        
        //发送账号密码
        Alamofire.request("https://192.168.0.106:8443/post", method: .post, parameters: send, encoding: JSONEncoding.default)
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
    
    func textwillchange(){
        let n = titlewrite.text?.characters.count
        titlenumber.text = "\(n!)"
        if n! >= 20 && n! <= 40{
            titlenumber.textColor = .orange
        } else if n! > 40 {
            titlenumber.textColor = .red
        }else {
            titlenumber.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        let n = textView.text.characters.count
        arriternumber.text = "\(n)"
        if n >= 200 && n <= 400{
            arriternumber.textColor = .orange
        } else if n > 400 {
            arriternumber.textColor = .red
        }else {
            arriternumber.textColor = .black
        }
    }
}
