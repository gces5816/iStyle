//
//  ViewController_Edit.swift
//  iStyle
//
//  Created by admin on 2019/3/10.
//  Copyright © 2019年 TingYu. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import SwiftSocket

class ViewController_Edit: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var canvas = UIView()
    var im = UIImage()
    var imageView = UIImageView()
    var scratchCardView: SKScratchCardView?
    var full_img: SKScratchCardView?
    @IBOutlet weak var base: UIView!
    
    @IBOutlet weak var customActivityIndicator: UIActivityIndicatorView!
    var custom_image: UIImage?
    var style_1: UIImage?
    var style_2: UIImage?
    var style_3: UIImage?
    var style_4: UIImage?
    var style_5: UIImage?
    var style_6: UIImage?
    var style_7: UIImage?
    var style_8: UIImage?
    var style_9: UIImage?
    var style_10: UIImage?
    
    var p_1: UIImage?
    var p_2: UIImage?
    var p_3: UIImage?
    var p_4: UIImage?
    var p_5: UIImage?
    var p_6: UIImage?
    var p_7: UIImage?
    var p_8: UIImage?
    var p_9: UIImage?
    var p_10: UIImage?
    
    var b_1: UIImage?
    var b_2: UIImage?
    var b_3: UIImage?
    var b_4: UIImage?
    var b_5: UIImage?
    var b_6: UIImage?
    var b_7: UIImage?
    var b_8: UIImage?
    var b_9: UIImage?
    var b_10: UIImage?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sizeLabel: UILabel!
    
    
    @IBOutlet weak var custom: UIButton!
    @IBOutlet weak var style1: UIButton!
    @IBOutlet weak var style2: UIButton!
    @IBOutlet weak var style3: UIButton!
    @IBOutlet weak var style4: UIButton!
    @IBOutlet weak var style5: UIButton!
    @IBOutlet weak var style6: UIButton!
    @IBOutlet weak var style7: UIButton!
    @IBOutlet weak var style8: UIButton!
    @IBOutlet weak var style9: UIButton!
    @IBOutlet weak var style10: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCanvas()
        imageView.image = im
        addView2Canvas(imageView)
        customActivityIndicator.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        doubleTap()
        set_long_press()
    }
    
    // 設定Button長按功能
    func set_long_press() {
        let long_c = UILongPressGestureRecognizer(target: self, action: #selector(longTap_c(_:)))
        let long_1 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_1(_:)))
        let long_2 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_2(_:)))
        let long_3 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_3(_:)))
        let long_4 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_4(_:)))
        let long_5 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_5(_:)))
        let long_6 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_6(_:)))
        let long_7 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_7(_:)))
        let long_8 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_8(_:)))
        let long_9 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_9(_:)))
        let long_10 = UILongPressGestureRecognizer(target: self, action: #selector(longTap_10(_:)))
        
        custom.addGestureRecognizer(long_c)
        style1.addGestureRecognizer(long_1)
        style2.addGestureRecognizer(long_2)
        style3.addGestureRecognizer(long_3)
        style4.addGestureRecognizer(long_4)
        style5.addGestureRecognizer(long_5)
        style6.addGestureRecognizer(long_6)
        style7.addGestureRecognizer(long_7)
        style8.addGestureRecognizer(long_8)
        style9.addGestureRecognizer(long_9)
        style10.addGestureRecognizer(long_10)
    }
    
    @objc func longTap_c(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "選取風格圖片", style: .default, handler: { action in
                let picker: UIImagePickerController = UIImagePickerController()
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false // 可對照片作編輯
                    picker.delegate = self
                    self.present(picker, animated: true, completion: nil)
                }
            })
            let background = UIAlertAction(title: "清除目前風格", style: .default, handler: { action in
                self.custom_image = nil
                self.doubleTap_custom()
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    // 取得選取後的照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil) // 關掉
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            customActivityIndicator.startAnimating()
            uploadImage(image)
        }
    }
    // 上傳選擇的圖片
    func uploadImage(_ img: UIImage) {
        let storageRef = Storage.storage().reference().child("Image").child("custom.jpg")
        let imageData = img.jpegData(compressionQuality: 0.7)
        storageRef.putData(imageData!)
        socket()
    }
    // 與server通訊
    func socket() {
        let client = TCPClient(address: "120.126.145.216", port: 6669)
        
        switch client.connect(timeout: 30) {
        case .success:
            switch client.send(string: "custom" ) {
            case .success:
                print("send custom success")
                DispatchQueue.global(qos: .background).async {
                    while true{
                        let data = client.read(1024*10)
                        let def: [uint_fast8_t] = [0]
                        if let response = String(bytes: data ?? def, encoding: .utf8) {
                            if response == "7" {
                                DispatchQueue.main.async {
                                    self.get_image()
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
    // 下載自訂風格圖片
    func get_image() {
        let c = Database.database().reference().child("custom")
        
        let refHandle1 = c.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let value = snapshot.value as? NSDictionary
            
            let s = value?["custom"] as? String ?? ""
            let imdata = Data(base64Encoded: s)// base64 string -> Data
            self.custom_image = UIImage(data: imdata!)// data -> UIimage
        })
        self.doubleTap_custom()
        self.customActivityIndicator.stopAnimating()
    }
    
    @objc func longTap_1(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_1)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_1)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_2(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_2)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_2)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_3(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_3)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_3)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_4(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_4)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_4)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_5(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_5)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_5)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_6(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_6)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_6)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_7(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_7)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_7)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_8(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_8)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_8)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_9(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_9)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_9)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func longTap_10(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            let controller = UIAlertController(title: "自動套用風格：", message: nil, preferredStyle: .actionSheet)
            let person = UIAlertAction(title: "人物", style: .default, handler: { action in
                self.clear()
                let p = UIImageView(image: self.p_10)
                self.addView2Canvas(p)
            })
            let background = UIAlertAction(title: "背景", style: .default, handler: { action in
                self.clear()
                let b = UIImageView(image: self.b_10)
                self.addView2Canvas(b)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(person)
            controller.addAction(background)
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    // 設定畫布
    func setCanvas() {
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.contentMode = .scaleAspectFill
        
        base.addSubview(canvas)
        base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[canvas]-(0)-|",
                                                           options: NSLayoutConstraint.FormatOptions(),
                                                           metrics: nil,
                                                           views: ["canvas": canvas]))
        
        base.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[canvas]-(0)-|",
                                                           options: NSLayoutConstraint.FormatOptions(),
                                                           metrics: nil,
                                                           views: ["canvas": canvas]))
    }
    
    // Button -> Custom
    @IBAction public func custom(_ sender: UIButton){
        clear()
        let custom = UIImageView(image: custom_image)
        setScratchView(custom)
    }
    
    // Button -> Style-1: Flower
    @IBAction public func style_1(_ sender: UIButton){
        clear()
        let styleImage_1 = UIImageView(image: style_1)
        setScratchView(styleImage_1)
    }
    
    // Button -> Style-2: Geometric
    @IBAction func style_2(_ sender: UIButton){
        clear()
        let styleImage_2 = UIImageView(image: style_2)
        setScratchView(styleImage_2)
    }
    
    // Button -> Style-3: Rain_Princess
    @IBAction func style_3(_ sender: UIButton){
        clear()
        let styleImage_3 = UIImageView(image: style_3)
        setScratchView(styleImage_3)
    }
    
    // Button -> Style-4: Sky
    @IBAction func style_4(_ sender: UIButton){
        clear()
        let styleImage_4 = UIImageView(image: style_4)
        setScratchView(styleImage_4)
    }
    
    // Button -> Style-5: The_Scream
    @IBAction func style_5(_ sender: UIButton){
        clear()
        let styleImage_5 = UIImageView(image: style_5)
        setScratchView(styleImage_5)
    }
    
    // Button -> Style-6: Wave
    @IBAction func style_6(_ sender: UIButton){
        clear()
        let styleImage_6 = UIImageView(image: style_6)
        setScratchView(styleImage_6)
    }
    
    // Button -> Style-7: Mona_Lisa
    @IBAction func style_7(_ sender: UIButton){
        clear()
        let styleImage_7 = UIImageView(image: style_7)
        setScratchView(styleImage_7)
    }
    
    // Button -> Style-8: Japan
    @IBAction func style_8(_ sender: UIButton){
        clear()
        let styleImage_8 = UIImageView(image: style_8)
        setScratchView(styleImage_8)
    }
    
    // Button -> Style-9: Cool
    @IBAction func style_9(_ sender: UIButton){
        clear()
        let styleImage_9 = UIImageView(image: style_9)
        setScratchView(styleImage_9)
    }
    
    // Button -> Style-10: Dance
    @IBAction func style_10(_ sender: UIButton){
        clear()
        let styleImage_10 = UIImageView(image: style_10)
        setScratchView(styleImage_10)
    }
    
    // Button -> Eraser
    @IBAction func eraser(_ sender: UIButton){
        clear()
        let eraser = UIImageView(image: im)
        setScratchView(eraser)
    }
    
    func setScratchView(_ style: UIImageView) {
        style.contentMode = .scaleAspectFit
        
        scratchCardView = SKScratchCardView(frame: canvas.frame)
        scratchCardView?.contentMaskView.strokeWidth = CGFloat(slider.value)
        scratchCardView?.doubleTap = 0
        scratchCardView!.style(contentView: style)
        addView2Canvas(scratchCardView!)
    }
    
    func addView2Canvas(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.contentMode = .scaleAspectFit
        
        canvas.addSubview(subview)
        canvas.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[subview]-(0)-|",
                                                             options: NSLayoutConstraint.FormatOptions(),
                                                             metrics: nil,
                                                             views: ["subview": subview]))
        
        canvas.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[subview]-(0)-|",
                                                             options: NSLayoutConstraint.FormatOptions(),
                                                             metrics: nil,
                                                             views: ["subview": subview]))
    }
    
    // 設定Button雙擊功能
    func doubleTap_custom() {
        // 設定雙擊
        let tap = UITapGestureRecognizer(target: self, action: #selector(dt_custom))
        tap.numberOfTapsRequired = 2
        custom.addGestureRecognizer(tap)
    }
    
    func doubleTap() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(dt1))
        tap1.numberOfTapsRequired = 2
        style1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(dt2))
        tap2.numberOfTapsRequired = 2
        style2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(dt3))
        tap3.numberOfTapsRequired = 2
        style3.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(dt4))
        tap4.numberOfTapsRequired = 2
        style4.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(dt5))
        tap5.numberOfTapsRequired = 2
        style5.addGestureRecognizer(tap5)
        
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(dt6))
        tap6.numberOfTapsRequired = 2
        style6.addGestureRecognizer(tap6)
        
        let tap7 = UITapGestureRecognizer(target: self, action: #selector(dt7))
        tap7.numberOfTapsRequired = 2
        style7.addGestureRecognizer(tap7)
        
        let tap8 = UITapGestureRecognizer(target: self, action: #selector(dt8))
        tap8.numberOfTapsRequired = 2
        style8.addGestureRecognizer(tap8)
        
        let tap9 = UITapGestureRecognizer(target: self, action: #selector(dt9))
        tap9.numberOfTapsRequired = 2
        style9.addGestureRecognizer(tap9)
        
        let tap10 = UITapGestureRecognizer(target: self, action: #selector(dt10))
        tap10.numberOfTapsRequired = 2
        style10.addGestureRecognizer(tap10)
    }
    
    // 雙擊function
    @objc func dt_custom() {
        clear()
        addView2Canvas(UIImageView(image: custom_image))
    }
    
    @objc func dt1() {
        clear()
        addView2Canvas(UIImageView(image: style_1))
    }
    
    @objc func dt2() {
        clear()
        addView2Canvas(UIImageView(image: style_2))
    }
    
    @objc func dt3() {
        clear()
        addView2Canvas(UIImageView(image: style_3))
    }
    
    @objc func dt4() {
        clear()
        addView2Canvas(UIImageView(image: style_4))
    }
    
    @objc func dt5() {
        clear()
        addView2Canvas(UIImageView(image: style_5))
    }
    
    @objc func dt6() {
        clear()
        addView2Canvas(UIImageView(image: style_6))
    }
    
    @objc func dt7() {
        clear()
        addView2Canvas(UIImageView(image: style_7))
    }
    
    @objc func dt8() {
        clear()
        addView2Canvas(UIImageView(image: style_8))
    }
    
    @objc func dt9() {
        clear()
        addView2Canvas(UIImageView(image: style_9))
    }
    
    @objc func dt10() {
        clear()
        addView2Canvas(UIImageView(image: style_10))
    }
    
    // 清除無用subview
    func clear() {
        resizeImageViewToFitImageSize(imageView) //get image size
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size) //set output image size
        let X = -(canvas.bounds.width - imageView.bounds.width)/2
        let Y = -(canvas.bounds.height - imageView.bounds.height)/2
        let saveArea = CGRect(x: X, y: Y, width: canvas.bounds.width, height: canvas.bounds.height)
        let img = renderer.image { ctx in
            canvas.drawHierarchy(in: saveArea, afterScreenUpdates: true)
        }
        scratchCardView?.removeFromSuperview()
        canvas.removeFromSuperview()
        setCanvas()
        imageView.image = img
        addView2Canvas(imageView)
    }
    
    // Slider -> 筆觸大小
    @IBAction func slider(_ sender: UISlider) {
        scratchCardView?.contentMaskView.strokeWidth = CGFloat(sender.value)
        sizeLabel.text = String(format: "%.1f", sender.value)
    }
    
    // Button -> 儲存
    @IBAction func save() {
        resizeImageViewToFitImageSize(imageView) //get image size
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size) //set output image size
        let X = -(canvas.bounds.width - imageView.bounds.width)/2
        let Y = -(canvas.bounds.height - imageView.bounds.height)/2
        let saveArea = CGRect(x: X, y: Y, width: canvas.bounds.width, height: canvas.bounds.height)// +0.5
        let img = renderer.image { ctx in
            canvas.drawHierarchy(in: saveArea, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        
        //儲存成功提示
        let alertController = UIAlertController(title: "儲存成功", message: "影像已存入相簿", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resizeImageViewToFitImageSize(_ imageView:UIImageView) {
        let x = imageView.center.x
        let y = imageView.center.y
        let widthRatio = imageView.bounds.size.width / imageView.image!.size.width
        let heightRatio = imageView.bounds.size.height / imageView.image!.size.height
        let scale = min(widthRatio, heightRatio)
        let imageWidth = scale * imageView.image!.size.width
        let imageHeight = scale * imageView.image!.size.height
//        print("\(imageWidth) - \(imageHeight)")
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView.center.x = x
        imageView.center.y = y
    }
    
    // Button -> 重置
    @IBAction func reset(_ sender: UIButton){
        canvas.removeFromSuperview()
        setCanvas()
        imageView.image = im
        addView2Canvas(imageView)
    }
    
    // Button -> 返回主畫面
    @IBAction func Back2MainStoryBoard(_ sender: UIButton) {
        let stroyboard = UIStoryboard(name: "Main", bundle: nil) // 生成要切換的Stroyboard
        if let controller = stroyboard.instantiateViewController(withIdentifier: "Main") as?
            ViewController_Main { // 生成切換Stroyboard的controller
            present(controller, animated: false, completion: nil) // 顯示下一個畫面，使用present
            //navigationController?.pushViewController(controller, animated: true) // 顯示下一個畫面，使用push
        }
    }
}
