//
//  GrayButton.swift
//  JPulikkottil
//
//  Created by Aneesha Azeez on 10/17/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import UIKit

class GrayButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .grayButtonColor()
        setTitleColor(.whiteColor(), for: .normal)
        setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.disabled)
        titleLabel?.font = .heavy(15)
    }
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.orangeButtonHighlightColor() : UIColor.orangeButtonColor()
        }
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = UIColor.orangeButtonColor()
            } else {
                backgroundColor = UIColor.grayButtonColor()
            }
        }
    }
}

