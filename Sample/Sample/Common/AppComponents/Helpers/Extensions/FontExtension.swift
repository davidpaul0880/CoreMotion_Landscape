//
//  FontExtension.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 19/04/16.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class func regular(_ sizee: CGFloat = 15) -> UIFont {
        return FontFamily.regular.font(sizee) ?? UIFont.systemFont(ofSize: sizee)
    }
    class func light(_ sizee: CGFloat = 14) -> UIFont {
        return FontFamily.light.font(sizee) ?? UIFont.systemFont(ofSize: sizee)
    }
    class func heavy(_ sizee: CGFloat = 24) -> UIFont {
        return FontFamily.heavy.font(sizee) ?? UIFont.systemFont(ofSize: sizee)
    }
   class func medium(_ sizee: CGFloat = 18) -> UIFont {
        return FontFamily.medium.font(sizee) ?? UIFont.systemFont(ofSize: sizee)
    }
}
