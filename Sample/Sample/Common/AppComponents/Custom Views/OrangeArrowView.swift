//
//  OrangeArrowView.swift
//  BitReel
//
//  Created by Admin on 27/10/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import Foundation
import UIKit
class OrangeArrowView: UIView {
    var isUpwards: Bool = false
    init(isUpwards: Bool) {
        self.isUpwards = isUpwards
        super.init(frame: CGRect.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let mask = CAShapeLayer()
        mask.frame = layer.bounds
        let width = layer.frame.size.width
        let height = layer.frame.size.height
        //make path
        let path = CGMutablePath()
        if isUpwards {
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width/2, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width, y: height/2))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
        mask.path = path
        // CGPathRelease(path); - not needed
        layer.mask = mask
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = path
        //shape.lineWidth = 3.0
        //shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.orangeButtonColor().cgColor
        layer.insertSublayer(shape, at: 0)
    }
}

