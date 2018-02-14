//
//  Fonts.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 25/04/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import Foundation
import UIKit

enum FontFamily: String {
    case regular = "Lato-Regular"
    case semiBold = "Lato-Semibold"
    case light = "Lato-Light"
    case medium = "Lato-Medium"
    case heavy = "Lato-Heavy"
   func font(_ size: CGFloat) -> UIFont? { return UIFont(name: self.rawValue, size: size)}
}
