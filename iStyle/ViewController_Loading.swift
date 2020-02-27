//
//  ViewController_Loading.swift
//  iStyle
//
//  Created by admin on 2019/4/19.
//  Copyright © 2019年 TingYu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import SwiftSocket

class ViewController_Loading: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var im = UIImage()
    var style: [UIImage] = []
    let controller = UIStoryboard(name: "Edit", bundle: nil).instantiateViewController(withIdentifier: "Edit") as? ViewController_Edit
    let storage = Storage.storage().reference()
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var state_label: UILabel!
    
    @IBOutlet weak var myGif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0.0 // 初始化進度條
//        progress.transform = CGAffineTransform(scaleX: 1.0, y: 5.0) // 將進度條變寬5倍
        controller?.im = im
        state_label.text = String("上傳圖片中")
        myGif.loadGif(name: "s")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progress.setProgress(0.2, animated: true)
        uploadImage()
//        present(controller!, animated: false, completion: nil)
    }
    
    // 上傳選擇的圖片
    func uploadImage() {
        let storageRef = Storage.storage().reference().child("Image").child("original.jpg")
        let imageData = im.jpegData(compressionQuality: 0.7)
//        let imageData = im.pngData()
        storageRef.putData(imageData!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.state_label.text = String("製作風格中...")
        }
        socket()
    }
    
    // 與server通訊
    func socket() {
        let client = TCPClient(address: "120.126.145.216", port: 6669)

        switch client.connect(timeout: 30) {
        case .success:
            switch client.send(string: "shit" ) {
            case .success:
                print("send shit success")
                DispatchQueue.global(qos: .background).async {
                    while true{
                        let data = client.read(1024*10)
                        let def: [uint_fast8_t] = [0]
                        if let response = String(bytes: data ?? def, encoding: .utf8) {
                            if response == "6" {
                                DispatchQueue.main.async {
                                    self.p()
                                }
                                client.close()
                                break
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func p() {
        progress.setProgress(0.6, animated: true)
        state_label.text = String("正在載入風格")
        get_image()
    }
    
    // 下載圖片
    func get_image() {
        let style = Database.database().reference().child("style")
        let person = Database.database().reference().child("person")
        let background = Database.database().reference().child("background")
        
        
        let refHandle1 = style.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let value = snapshot.value as? NSDictionary
            
            let s1 = value?["1"] as? String ?? ""
            let imdata1 = Data(base64Encoded: s1)// base64 string -> Data
            self.controller?.style_1 = UIImage(data: imdata1!)// data -> UIimage
            
            let s2 = value?["2"] as? String ?? ""
            let imdata2 = Data(base64Encoded: s2)// base64 string -> Data
            self.controller?.style_2 = UIImage(data: imdata2!)
            
            let s3 = value?["3"] as? String ?? ""
            let imdata3 = Data(base64Encoded: s3)// base64 string -> Data
            self.controller?.style_3 = UIImage(data: imdata3!)

            let s4 = value?["4"] as? String ?? ""
            let imdata4 = Data(base64Encoded: s4)// base64 string -> Data
            self.controller?.style_4 = UIImage(data: imdata4!)

            let s5 = value?["5"] as? String ?? ""
            let imdata5 = Data(base64Encoded: s5)// base64 string -> Data
            self.controller?.style_5 = UIImage(data: imdata5!)

            let s6 = value?["6"] as? String ?? ""
            let imdata6 = Data(base64Encoded: s6)// base64 string -> Data
            self.controller?.style_6 = UIImage(data: imdata6!)

            let s7 = value?["7"] as? String ?? ""
            let imdata7 = Data(base64Encoded: s7)// base64 string -> Data
            self.controller?.style_7 = UIImage(data: imdata7!)

            let s8 = value?["8"] as? String ?? ""
            let imdata8 = Data(base64Encoded: s8)// base64 string -> Data
            self.controller?.style_8 = UIImage(data: imdata8!)

            let s9 = value?["9"] as? String ?? ""
            let imdata9 = Data(base64Encoded: s9)// base64 string -> Data
            self.controller?.style_9 = UIImage(data: imdata9!)

            let s10 = value?["10"] as? String ?? ""
            let imdata10 = Data(base64Encoded: s10)// base64 string -> Data
            self.controller?.style_10 = UIImage(data: imdata10!)
        })
        
        let refHandle2 = person.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let value = snapshot.value as? NSDictionary
            
            let p1 = value?["p1"] as? String ?? ""
            let pdata1 = Data(base64Encoded: p1)
            self.controller?.p_1 = UIImage(data: pdata1!)
            
            let p2 = value?["p2"] as? String ?? ""
            let pdata2 = Data(base64Encoded: p2)
            self.controller?.p_2 = UIImage(data: pdata2!)
            
            let p3 = value?["p3"] as? String ?? ""
            let pdata3 = Data(base64Encoded: p3)
            self.controller?.p_3 = UIImage(data: pdata3!)
            
            let p4 = value?["p4"] as? String ?? ""
            let pdata4 = Data(base64Encoded: p4)
            self.controller?.p_4 = UIImage(data: pdata4!)
            
            let p5 = value?["p5"] as? String ?? ""
            let pdata5 = Data(base64Encoded: p5)
            self.controller?.p_5 = UIImage(data: pdata5!)
            
            let p6 = value?["p6"] as? String ?? ""
            let pdata6 = Data(base64Encoded: p6)
            self.controller?.p_6 = UIImage(data: pdata6!)
            
            let p7 = value?["p7"] as? String ?? ""
            let pdata7 = Data(base64Encoded: p7)
            self.controller?.p_7 = UIImage(data: pdata7!)
            
            let p8 = value?["p8"] as? String ?? ""
            let pdata8 = Data(base64Encoded: p8)
            self.controller?.p_8 = UIImage(data: pdata8!)
            
            let p9 = value?["p9"] as? String ?? ""
            let pdata9 = Data(base64Encoded: p9)
            self.controller?.p_9 = UIImage(data: pdata9!)
            
            let p10 = value?["p10"] as? String ?? ""
            let pdata10 = Data(base64Encoded: p10)
            self.controller?.p_10 = UIImage(data: pdata10!)
        })
        
        let refHandle3 = background.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let value = snapshot.value as? NSDictionary
            
            let p1 = value?["b1"] as? String ?? ""
            let pdata1 = Data(base64Encoded: p1)
            self.controller?.b_1 = UIImage(data: pdata1!)
            
            let p2 = value?["b2"] as? String ?? ""
            let pdata2 = Data(base64Encoded: p2)
            self.controller?.b_2 = UIImage(data: pdata2!)
            
            let p3 = value?["b3"] as? String ?? ""
            let pdata3 = Data(base64Encoded: p3)
            self.controller?.b_3 = UIImage(data: pdata3!)
            
            let p4 = value?["b4"] as? String ?? ""
            let pdata4 = Data(base64Encoded: p4)
            self.controller?.b_4 = UIImage(data: pdata4!)
            
            let p5 = value?["b5"] as? String ?? ""
            let pdata5 = Data(base64Encoded: p5)
            self.controller?.b_5 = UIImage(data: pdata5!)
            
            let p6 = value?["b6"] as? String ?? ""
            let pdata6 = Data(base64Encoded: p6)
            self.controller?.b_6 = UIImage(data: pdata6!)
            
            let p7 = value?["b7"] as? String ?? ""
            let pdata7 = Data(base64Encoded: p7)
            self.controller?.b_7 = UIImage(data: pdata7!)
            
            let p8 = value?["b8"] as? String ?? ""
            let pdata8 = Data(base64Encoded: p8)
            self.controller?.b_8 = UIImage(data: pdata8!)
            
            let p9 = value?["b9"] as? String ?? ""
            let pdata9 = Data(base64Encoded: p9)
            self.controller?.b_9 = UIImage(data: pdata9!)
            
            let p10 = value?["b10"] as? String ?? ""
            let pdata10 = Data(base64Encoded: p10)
            self.controller?.b_10 = UIImage(data: pdata10!)
        })
        
        jump()
    }
    
    func jump() {
        progress.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.state_label.text = String("完成")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.present(self.controller!, animated: false, completion: nil)
        }
    }
    
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
