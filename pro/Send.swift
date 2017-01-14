//
//  Send.swift
//  pro
//
//  Created by 胡康泽 on 14/01/2017.
//  Copyright © 2017 胡康泽. All rights reserved.
//

import Foundation
import UIKit

class Send: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate{
    @IBAction func send(_ sender: Any) {
        
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var arriternumber: UILabel!
    @IBOutlet weak var titlenumber: UILabel!
    @IBOutlet weak var titlewrite: UITextField!
    
    @IBOutlet weak var uipicker: UIPickerView!
    var type: Int?
    var colors = ["未选择","心情文章","硬件疑问","软件疑问","装机配置","见闻"]
    var keyHeight = CGFloat() //键盘的高度
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlewrite.addTarget(self, action: #selector(Send.textwillchange), for: UIControlEvents.editingChanged)
        titlewrite.returnKeyType = UIReturnKeyType.done
        let screenBounds:CGRect = UIScreen.main.bounds
        let textview = UITextView(frame:CGRect(x:titlewrite.frame.origin.x, y:titlewrite.frame.origin.y + titlewrite.frame.size.height + 3, width:titlewrite.frame.width, height:screenBounds.height - (titlewrite.frame.origin.y + titlewrite.frame.size.height + 3) - 258))
        textview.layer.borderWidth = 1  //边框粗细
        textview.layer.borderColor = UIColor.gray.cgColor //边框颜色
        self.view.addSubview(textview)
        textview.delegate = self
        textview.isEditable = true
        textview.isSelectable = true
        titlewrite.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return colors.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "SanFranciscoText-Light", size: 30)
        label.text = colors[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //将在滑动停止后触发，并打印出选中列和行索引
        type = row
    }
    
    func textwillchange(){
        let n = titlewrite.text?.characters.count
        titlenumber.text = "\(n!)"
        if n! >= 20 && n! <= 40{
            titlenumber.textColor = .orange
        } else if n! > 40 {
            titlenumber.textColor = .red
        }else {
            titlenumber.textColor = .white
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let n = textView.text.characters.count
        arriternumber.text = "\(n)"
        if n >= 200 && n <= 400{
            arriternumber.textColor = .orange
        } else if n > 400 {
            arriternumber.textColor = .red
        }else {
            arriternumber.textColor = .white
        }
    }
}
