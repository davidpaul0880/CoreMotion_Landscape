//
//  SpinnerView.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 18/04/16.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import UIKit

class SpinnerView: UIView {

    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var lblMessage: UILabel!
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    var isAnimating: Bool {
        return indicatorView.isAnimating
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        backgroundColor = UIColor.clear
        //indicatorView.tintColor = UIColor.buttonBackground()
        let bgViewWidth: CGFloat = 60 //20171220 80 -> 60
        let bgView = UIView(frame: CGRect(x: frame.size.width / 2 - bgViewWidth / 2, y: ((frame.size.height) / 2 - bgViewWidth / 2) - 54, width: bgViewWidth, height: bgViewWidth)) //20171220  - 54 to adjust indicator abouve the text in video upload screen
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor.themeColorDark().withAlphaComponent(0.5)
        addSubview(bgView)

        indicatorView.hidesWhenStopped = true
        let widthh = CGFloat(indicatorView.intrinsicContentSize.width)
        let frame = CGRect(x: bgView.frame.size.width / 2 - widthh / 2, y: (bgView.frame.size.height) / 2 - widthh / 2, width: widthh, height: widthh)
        indicatorView.frame = frame

        //        let yPos = indicatorView.frame.origin.y + indicatorView.frame.size.height
        //
        //        lblMessage = UILabel(frame: CGRect(x: 0, y: yPos, width: self.frame.size.width, height: 100))
        //        lblMessage.textAlignment = .center
        //        lblMessage.text = "Loading..."
        //        lblMessage.numberOfLines = 0
        //        lblMessage.sizeToFit()
        bgView.addSubview(indicatorView)
        //self.addSubview(lblMessage)
        indicatorView.startAnimating()

    }
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        let frame = bounds
        backgroundColor = UIColor.clear
        let widthh = CGFloat(20.0)
        let frameIndicator = CGRect(x: frame.size.width / 2 - widthh / 2, y: frame.size.height / 2 - widthh / 2, width: widthh, height: widthh)
        indicatorView.frame = frameIndicator
        addSubview(indicatorView)
    }

    func startAnimate() {
        indicatorView.startAnimating()
        //isAnimating = true
    }

    func stopAnimate() {
        indicatorView.stopAnimating()
        //isAnimating = false
    }
}
