//
//  StringExtensions.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 07/04/16.
//  Copyright © 2017 JPulikkottil All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    public static func getVisibleViewControllerFrom(_ viewCtrlr: UIViewController?) -> UIViewController? {
        if let nc = viewCtrlr as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = viewCtrlr as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = viewCtrlr?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return viewCtrlr
            }
        }
    }
}

extension NSAttributedString {

    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return boundingBox.height
    }

    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return boundingBox.width
    }

}

extension String {

    var toJSON: Any? {

        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)

        if let jsonData = data {
            do {
            // Will return an object or nil if JSON decoding fails
                return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
            } catch {
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }

    func toData() -> Data {

        return self.data(using: String.Encoding.utf8) ?? Data()
    }

    func startsWith(_ string: String) -> Bool {

        guard let range = range(of: string, options: [.caseInsensitive, .anchored], range: nil, locale: nil) else {
            return false
        }

        return range.lowerBound == startIndex
    }

    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return boundingBox.width
    }
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return boundingBox.height
    }

    func substringFromIndex(_ index: Int) -> String {
        let indexStartOfText = self.index(self.startIndex, offsetBy: index)
        return String(self[indexStartOfText...])
    }
    func substringToIndex(_ index: Int) -> String {
        let indexStartOfText = self.index(self.startIndex, offsetBy: index)
        return String(self[..<indexStartOfText])
    }
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func validateEmail() -> Bool {

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }

    func isAlphanumeric() -> Bool {
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits

        var letterCount = 0
        var digitCount = 0

        for uni in self.unicodeScalars {
            if let letter = UnicodeScalar(uni.value), letters.contains(letter) {
                letterCount += 1
            } else if let digit = UnicodeScalar(uni.value), digits.contains(digit) {
                digitCount += 1
            }
        }
        if letterCount > 0 && digitCount > 0 {
            return true
        }
        return false
    }

//    var digits: String {
//        return components(separatedBy: CharacterSet.decimalDigits.inverted)
//            .joined()
//    }
    var length: Int {
        return count
    }
    func insertString(_ string: String, ind: Int) -> String {
        var newStr = self
        let startIndex = self.index(self.startIndex, offsetBy: ind)
        newStr.insert(contentsOf: string, at: startIndex)
        return newStr
    }

    func getSortingLetter() -> String {
        // get the first letter of the string
        let letter = self[0]
        if letter.rangeOfCharacter(from: NSCharacterSet.letters) != nil {
            // this is an alphabet
            // take the alphabet and return in capital letters
            return letter.uppercased()
        }
        return "#"
    }

    subscript (index: Int) -> String {
        return String(self[self.index(startIndex, offsetBy: index)])
    }
}
