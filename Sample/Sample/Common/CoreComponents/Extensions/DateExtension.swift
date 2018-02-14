//
//  DateExtension.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 11/07/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import Foundation
enum DateFormats: String {
    case jSONDate = "yyyy-MM-dd"
    case jSONDateTime = "yyyy-MM-dd'T'HH:mm:ss"
    case jSONDateTimeMillis = "yyyy-MM-dd HH:mm:ss.SSS"
    case dateOnluSlanding = "dd/MM/yyyy"
    case timeOnly = "hh:mm a"
    case shortTime = "h:mm a"
    case monthYear = "MMMM yyyy"
    case day = "EEEE"
    case customFullDateTimeShort = "MM/dd/yyyy hh:mm a"
    case customDateShort = "MM/dd/yyyy"
}

enum DateRoundingType {
    case round
    case ceil
    case floor
}

extension Date {
    static func fromString(_ dateStr: String?, format: DateFormats = .jSONDateTime) -> Date? {
        guard let dateString = dateStr else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: dateString)
    }
    func toGMTDisplayString() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: self)
    }
    func toGMTString(format: DateFormats = .jSONDateTime) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    func toDisplayString(format: DateFormats = .jSONDateTime) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    func toDisplayDate() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: self)
    }
    func toDisplayShortDate() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        return dateFormatter.string(from: self)
    }
    func toDisplayDateTime() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        return dateFormatter.string(from: self)
    }
    func numberOfWeeksRow() -> UInt {
        var numRows: UInt = 6
        let daysInWeek = 7
        if let daysInMonth = daysInCurrentMonth(), let startDay = firstDayNumberOfWeek() {
            numRows = UInt((startDay + daysInMonth - 1) / daysInWeek)
            if ((startDay+daysInMonth - 1) % daysInWeek) != 0 {
                numRows += 1
            }
        }
        return numRows
    }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    func firstDayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self.startOfMonth()).weekday
    }
    func daysInCurrentMonth() -> Int? {
        let calendar = Calendar.current
        // Calculate start and end of the current year (or month with `.month`):
        if #available(iOS 10.0, *) {
            if let interval = calendar.dateInterval(of: .month, for: self) {
                let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day
                return days
            }
        } else {
            // Fallback on earlier versions
            if let range = calendar.range(of: .day, in: .month, for: self) {
                return range.count
            }
        }
        return nil

    }
    func dayStartTime() -> Date {

        //Calendar(identifier: Calendar.Identifier.gregorian)
        return Calendar.current.startOfDay(for: self)
    }
    func endTimeAfterDays(_ afterDays: Double = 1) -> Date {
        var dateStart = dayStartTime()
        dateStart.addTimeInterval(afterDays * 24 * 60 * 60)
        return dateStart
    }
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }
    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
    func getMinutes() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.component(.minute, from: self)
    }
    func timeAgoSinceNow(useNumericDates: Bool = true) -> String {

        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let components = calendar.dateComponents(unitFlags, from: self, to: now)

        let formatter = DateComponentUnitFormatter()
        return formatter.string(forDateComponents: components, useNumericDates: useNumericDates)
    }
    func compareTo(_ date: Date, toGranularity: Calendar.Component ) -> ComparisonResult {
        let calendar = Calendar.current
        //calendar.timeZone = TimeZone(abbreviation: "GMT")!
        //calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.compare(self, to: date, toGranularity: toGranularity)
    }

}

struct DateComponentUnitFormatter {

    private struct DateComponentUnitFormat {
        let unit: Calendar.Component

        let singularUnit: String
        let pluralUnit: String

        let futureSingular: String
        let pastSingular: String
    }

    private let formats: [DateComponentUnitFormat] = [

        DateComponentUnitFormat(unit: .year,
                                singularUnit: "year",
                                pluralUnit: "years",
                                futureSingular: "Next year",
                                pastSingular: "Last year"),

        DateComponentUnitFormat(unit: .month,
                                singularUnit: "month",
                                pluralUnit: "months",
                                futureSingular: "Next month",
                                pastSingular: "Last month"),

        DateComponentUnitFormat(unit: .weekOfYear,
                                singularUnit: "week",
                                pluralUnit: "weeks",
                                futureSingular: "Next week",
                                pastSingular: "Last week"),

        DateComponentUnitFormat(unit: .day,
                                singularUnit: "day",
                                pluralUnit: "days",
                                futureSingular: "Tomorrow",
                                pastSingular: "Yesterday"),

        DateComponentUnitFormat(unit: .hour,
                                singularUnit: "hour",
                                pluralUnit: "hours",
                                futureSingular: "In an hour",
                                pastSingular: "An hour ago"),

        DateComponentUnitFormat(unit: .minute,
                                singularUnit: "minute",
                                pluralUnit: "minutes",
                                futureSingular: "In a minute",
                                pastSingular: "A minute ago"),

        DateComponentUnitFormat(unit: .second,
                                singularUnit: "second",
                                pluralUnit: "seconds",
                                futureSingular: "Just now",
                                pastSingular: "Just now")

        ]

    // swiftlint:disable cyclomatic_complexity
    func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool) -> String {
        for format in self.formats {
            let unitValue: Int

            switch format.unit {
            case .year:
                unitValue = dateComponents.year ?? 0
            case .month:
                unitValue = dateComponents.month ?? 0
            case .weekOfYear:
                unitValue = dateComponents.weekOfYear ?? 0
            case .day:
                unitValue = dateComponents.day ?? 0
            case .hour:
                unitValue = dateComponents.hour ?? 0
            case .minute:
                unitValue = dateComponents.minute ?? 0
            case .second:
                unitValue = dateComponents.second ?? 0
            default:
                assertionFailure("Date does not have requried components")
                return ""
            }

            switch unitValue {
            case 2 ..< Int.max:
                return "\(unitValue) \(format.pluralUnit) ago"
            case 1:
                return useNumericDates ? "\(unitValue) \(format.singularUnit) ago" : format.pastSingular
            case -1:
                return useNumericDates ? "In \(-unitValue) \(format.singularUnit)" : format.futureSingular
            case Int.min ..< -1:
                return "In \(-unitValue) \(format.pluralUnit)"
            default:
                break
            }
        }

        return "Just now"
    }
}

