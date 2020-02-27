//
//  ViewController.swift
//  iStyle
//
//  Created by admin on 2019/3/5.
//  Copyright © 2019年 TingYu. All rights reserved.
//

import UIKit

class ViewController_Main: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // 開啟相機或相簿
    func callGetPhoneWithKind(_ kind: Int) {
        let picker: UIImagePickerController = UIImagePickerController()
        switch kind {
        case 1:
            // 開啟相機
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                picker.sourceType = .camera
                picker.allowsEditing = false // 可對照片作編輯
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        default:
            // 開啟相簿
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                picker.sourceType = .photoLibrary
                picker.allowsEditing = false // 可對照片作編輯
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
    
    // 取得選取後的照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil) // 關掉
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            Loading(image)
        }
    }
    
    // 圖片picker控制器任務結束回呼
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 跳轉Loading畫面
    func Loading(_ image: UIImage) {
//        let stroyboard = UIStoryboard(name: "Edit", bundle: nil) // 生成要切換的Stroyboard
        let stroyboard = UIStoryboard(name: "Loading", bundle: nil) // 生成要切換的Stroyboard
//        if let controller = stroyboard.instantiateViewController(withIdentifier: "Edit") as? ViewController_Edit { // 生成切換Stroyboard的controller
        if let controller = stroyboard.instantiateViewController(withIdentifier: "Loading") as? ViewController_Loading { // 生成切換Stroyboard的controller
            controller.im = image
            present(controller, animated: false, completion: nil) // 顯示下一個畫面，使用present
        }
    }
    
    // Button -> 開啟相機
    @IBAction func CameraBtn_onClick(_ sender: UIButton) {
        self.callGetPhoneWithKind(1)
    }
    
    // Button -> 開啟相簿
    @IBAction func LibraryBtn_onClick(_ sender: UIButton) {
        self.callGetPhoneWithKind(2)
    }
    
}
