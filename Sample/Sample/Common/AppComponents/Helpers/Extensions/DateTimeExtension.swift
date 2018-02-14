//
//  DateTimeExtension.swift
//  JPulikkottil
//
//  Created by deepak.palangadan on 24/11/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import Foundation
extension Date {
    static func getTodaysDateWithTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "YYYYMMdd_HHmmss"
        let now = formatter.string(from: date)
        return now
    }
    static  func getTodaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "YYYYMMdd"
        let now = formatter.string(from: date)
        return now
    }
}
