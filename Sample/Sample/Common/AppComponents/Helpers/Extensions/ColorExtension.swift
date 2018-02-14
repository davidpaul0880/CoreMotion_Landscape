//
//  ColorExtension.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 26/04/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func navigationBarBackground() -> UIColor {
        return UIColor(named: .themeColorDark)
    }
    class func primaryColor() -> UIColor {
        return UIColor(named: .themeColor)
    }
    class func secondaryColor() -> UIColor {
        return UIColor(named: .themeColor)
    }
    class func ternaryColor() -> UIColor {
        return UIColor(named: .themeColor)
    }
    class func themeColorLight() -> UIColor {
        return UIColor(named: .themeColorLight)
    }
    class func themeColorDark() -> UIColor {
        return UIColor(named: .themeColorDark)
    }
    class func orangeButtonColor() -> UIColor {
        return UIColor(named: .orangeButtonColor)
    }
    class func whiteColor() -> UIColor {
        return UIColor(named: .whiteColor)
    }
    class func grayButtonColor() -> UIColor {
        return UIColor(named: .grayButtonColor)
    }
    class func orangeButtonHighlightColor() -> UIColor {
        return UIColor(named: .orangeButtonHighlightColor)
    }
}
