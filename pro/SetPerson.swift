//
//  SetPerson.swift
//  pro
//
//  Created by 胡康泽 on 2016/11/21.
//  Copyright © 2016年 胡康泽. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class SetPerson: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var namebu: UIBarButtonItem!
    @IBOutlet weak var chance: UIButton!
    @IBOutlet weak var gold: UILabel!
    @IBOutlet weak var silver: UILabel!
    @IBOutlet weak var copper: UILabel!
    @IBOutlet weak var tupian: UIImageView!
    @IBOutlet weak var touxiang: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBAction func turnAn(_ sender: Any) {
        if namebu.title == "登录"{
            self.performSegue(withIdentifier: "denglu", sender: self)
        } else {
            let cookieJar: Array = HTTPCookieStorage.shared.cookies(
                for: URL(string:"https://" + url.URLNAME + ":8443")!)!
            for i in cookieJar {
                HTTPCookieStorage.shared.deleteCookie(i as HTTPCookie)
            }
            gold.text = "\(0)"
            silver.text = "\(0)"
            copper.text = "\(0)"
            tupian.image = UIImage(named: "自定义头像")
            touxiang.text = "请登录"
            level.text = "未知生物"
            namebu.title = "登录"
            chance.isHidden = true
        }
    }
    @IBAction func chance_p(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let archiveAction = UIAlertAction(title: "拍照", style: .default, handler: {
            action in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                //创建图片控制器
                let picker = UIImagePickerController()
                //设置代理
                picker.delegate = self
                //设置来源
                picker.sourceType = UIImagePickerControllerSourceType.camera
                //允许编辑
                picker.allowsEditing = true
                //打开相机
                self.present(picker, animated: true, completion: { () -> Void in
                    
                })
            }else{
                let alertController = UIAlertController(title: "您的摄像头好像坏了",
                                                        message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            }
        })
        let carmAction = UIAlertAction(title: "从本地选择图片", style: .default, handler:{
        action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                //初始化图片控制器
                let picker = UIImagePickerController()
                //设置代理
                picker.delegate = self
                //指定图片控制器类型
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                picker.allowsEditing = true
                //弹出控制器，显示界面
                self.present(picker, animated: true, completion: {
                    () -> Void in
                })
            }else{
                let alertController = UIAlertController(title: "读取相册失败",
                                                        message: nil, preferredStyle: .alert)
                //显示提示框
                self.present(alertController, animated: true, completion: nil)
                //两秒钟后自动消失
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(archiveAction)
        alertController.addAction(carmAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func zhuToSet(segue: UIStoryboardSegue){
        if segue.identifier == "zhuToSet"{
            chance.isHidden = false
            let data = segue.source as! Zhu
            self.touxiang.text = data.account.text
            self.level.text = data.level
            let g = data.money / 10000
            let y = data.money % 10000 / 100
            let t = data.money % 10000 % 100
            self.gold.text = "\(g)"
            self.silver.text = "\(y)"
            self.copper.text = "\(t)"
            self.namebu.title = "退出"
            if data.photo != "null" {
                if let data: NSData = NSData(base64Encoded: data.photo!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                {
                    if let image_fl: UIImage = UIImage(data: data as Data) {
                        tupian.image = image_fl
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chance.isHidden = true
        namebu.title = "登录"
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image:UIImage!
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let image1 = compressedImageDataLenth(img: image, size: 1)
        let imageData = UIImagePNGRepresentation(image1)
        let base64 = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let send: Dictionary = ["Type": base64!] as [String : String]
        //给服务器发送请求，把信息发送回来
        Alamofire.request("https://" + url.URLNAME + ":8443/chance", method: .post, parameters: send, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let F = json["Port"].boolValue
                    if F {
                        picker.dismiss(animated: true, completion: {
                            () -> Void in
                        })
                        self.tupian.image = image1
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    private func compressedImageDataLenth(img:UIImage,size:Int) ->UIImage {
        var data:NSData?
        var dep:CGFloat = 1.0
        repeat {
            data = UIImageJPEGRepresentation(img, dep) as NSData?
            dep = dep - 0.1
        } while(data!.length >= size && dep > 0)
        
        return UIImage(data: data as! Data)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
