//
//  Colors.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 25/04/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import Foundation
import UIKit

enum ColorName: Int {

    case themeColorDark = 0x002c40
    case themeColor = 0x08738f
    case themeColorLight = 0x03a8bb
    case orangeButtonColor = 0xf9a324
    case whiteColor = 0xffffff
    case grayButtonColor = 0x808080
    case orangeButtonHighlightColor = 0xAE7318

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex: Int) {
        self.init(red: (CGFloat((netHex & 0xFF0000) >> 16) / CGFloat(255.0)), green: (CGFloat((netHex & 0xFF00) >> 8) / CGFloat(255.0)), blue: (CGFloat(netHex & 0xFF) / CGFloat(255.0)), alpha: 1.0)
    }
    convenience init(named name: ColorName) {
        self.init(netHex: name.rawValue)
    }
}
