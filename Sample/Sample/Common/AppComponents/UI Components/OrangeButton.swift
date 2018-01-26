//
//  OrangeButton.swift
//  BitReel
//
//  Created by Admin on 14/11/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import UIKit

class OrangeButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .orangeButtonColor()
        self.setTitleColor(.whiteColor(), for: .normal)
        //self.titleLabel?.font = .heavy(15)
    }
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.orangeButtonHighlightColor() : UIColor.orangeButtonColor()
        }
    }
}
