//
//  ArrowView.swift
//  video
//
//  Created by jijo pulikkottil on 21/10/17.
//  Copyright © 2017 jijo. All rights reserved.
//
import UIKit
import Foundation
class ArrowView: UIView {
    var isUpwards: Bool = false
    init(isUpwards: Bool) {
        self.isUpwards = isUpwards
        super.init(frame: CGRect.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        shape.lineWidth = 3.0
        shape.strokeColor = UIColor.themeColorDark().cgColor
        shape.fillColor = UIColor.themeColorLight().withAlphaComponent(0.75).cgColor
        layer.insertSublayer(shape, at: 0)
    }
}
