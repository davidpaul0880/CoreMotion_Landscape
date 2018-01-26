//
//  TextFieldExtension.swift
//  BitReel
//
//  Created by Aneesha Azeez on 10/17/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import Foundation
import UIKit
enum FieldType {
    case email
    case name
}
extension UITextField {
    func setKeyboardTypeFor(_ fieldType: FieldType) {
        self.keyboardType = .asciiCapable
        self.autocapitalizationType = .none
        self.returnKeyType = .next
        self.autocorrectionType = .no
        self.inputView = nil
        switch fieldType {
        case .name:
            self.autocapitalizationType = .words
            self.keyboardType = .asciiCapable
            self.textContentType = UITextContentType.name
        case .email:
            self.keyboardType = .emailAddress
            self.textContentType = UITextContentType.emailAddress
        }
    }
}
