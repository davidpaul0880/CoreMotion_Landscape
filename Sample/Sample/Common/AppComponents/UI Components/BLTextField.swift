//
//  BLTextField.swift
//  JPulikkottil
//
//  Created by Admin on 13/11/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import UIKit

class BLTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = .white
    }
}
