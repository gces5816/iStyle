//
//  SKScratchCardView.swift
//  iStyle
//
//  Created by admin on 2019/3/22.
//  Copyright © 2019年 TingYu. All rights reserved.
//

import UIKit

class SKScratchCardView: UIView {
    var coverView = UIView()
    var contentView = UIView()
    public var contentMaskView = SKScratchCardMaskView()
    public var doubleTap = 0
    
    
    var strokeWidth:CGFloat = 0 {
        didSet {
            self.contentMaskView.strokeWidth = self.strokeWidth
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviewFullscreen(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.contentMode = .scaleAspectFit
        addSubview(subview)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[subview]-(0)-|",
                                                      options: NSLayoutConstraint.FormatOptions(),
                                                      metrics: nil,
                                                      views: ["subview": subview]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[subview]-(0)-|",
                                                      options: NSLayoutConstraint.FormatOptions(),
                                                      metrics: nil,
                                                      views: ["subview": subview]))
    }
    
    private func setupPanGesture(_ MaskView: SKScratchCardMaskView) {
        let panGesture = UIPanGestureRecognizer(target: MaskView, action: #selector(MaskView.panGestureRecognizer))
        self.addGestureRecognizer(panGesture)
    }
    
    public func style(contentView:UIView) {
        // content view
        self.contentView = contentView // 風格圖
        
        // maskView
        self.contentMaskView.frame = contentView.frame
        if doubleTap == 0 {
            self.contentMaskView.backgroundColor = UIColor.clear
        }
        
        // addSubviews
        addSubviewFullscreen(self.contentView)
        
        // set mask
        self.contentView.mask = self.contentMaskView
        
        // add gesture
        setupPanGesture(contentMaskView)
    }
    
    public func clear() {
        contentMaskView.clear()
    }
    
}
