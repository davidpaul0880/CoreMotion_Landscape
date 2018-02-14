//
//  StringExtension.swift
//  JPulikkottil
//
//  Created by Aneesha Azeez on 10/19/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var validateZipCodeOnType: Bool {
        let characterSet = CharacterSet(charactersIn: "1234567890 ")
        let range = (self as NSString).rangeOfCharacter(from: characterSet.inverted)
        return  range.location != NSNotFound ||  self.trim().count > 5
    }
    var validateZipCode: Bool {
        let characterSet = CharacterSet(charactersIn: "1234567890")
        let range = (self as NSString).rangeOfCharacter(from: characterSet.inverted)
        return  range.location == NSNotFound &&  self.count == 5
    }
    func trimForZip() -> String {
        let characterSet = CharacterSet(charactersIn: ".").union(CharacterSet.whitespacesAndNewlines)
        return self.trimmingCharacters(in: characterSet)
    }
    func getMultiColorText(subString: String) -> NSAttributedString {
        var mutableString = NSMutableAttributedString()
        mutableString = NSMutableAttributedString(string: self)
        mutableString.setAttributes([NSAttributedStringKey.font: UIFont.regular(12),
                                     NSAttributedStringKey.foregroundColor: UIColor.white],
                                    range: NSRange(location: 0, length: self.length))
        let range = (self as NSString).range(of: subString)
        mutableString.setAttributes([NSAttributedStringKey.font: UIFont.heavy(12),
                                     NSAttributedStringKey.foregroundColor: UIColor.red],
                                    range: range)
        return mutableString
    }
    func validateUserName() -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!-_.*'() "
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        return self.rangeOfCharacter(from: cs) == nil
    }
    func validateString() -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!-_.*'() "
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        return self.rangeOfCharacter(from: cs) == nil
    }
}
