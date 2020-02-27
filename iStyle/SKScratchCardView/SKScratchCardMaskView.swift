//
//  SKScratchCardMaskView.swift
//  iStyle
//
//  Created by admin on 2019/3/22.
//  Copyright © 2019年 TingYu. All rights reserved.
//

import UIKit

class SKScratchCardMaskView: UIView {
    var strokeWidth: CGFloat = 15
    var strokeColor = UIColor.black
    
    var strokewidth: [CGFloat] = []
    
    public var paths: [CGMutablePath] = []
    public var currentPath: CGMutablePath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(strokeColor.cgColor)
        context?.setLineCap(.round)
        var count = 0
        for path in paths + [currentPath].compactMap({$0}) {
            context?.setLineWidth(strokewidth[count])
            context?.addPath(path)
            context?.strokePath()
            count = count + 1
        }
    }
    
    @objc func panGestureRecognizer(_ recognizer:UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        switch recognizer.state {
        case .began:
            beginPath(at: location)
            
        case .changed:
            addLine(to: location)
            
        default:
            closePath()
        }
    }
    
    public func beginPath(at point: CGPoint) {
        strokewidth.append(strokeWidth) // 記錄筆觸大小
        
        currentPath = CGMutablePath()
        currentPath?.move(to: point)
        setNeedsDisplay()
    }
    
    public func addLine(to point: CGPoint) {
        currentPath?.addLine(to: point)
        setNeedsDisplay()
    }
    
    public func closePath() {
        if let currentPath = currentPath {
            paths.append(currentPath)
            //print(paths)
        }
        setNeedsDisplay()
        currentPath = nil
    }
    
    public func clear() {
        paths.removeAll()
    }
}
