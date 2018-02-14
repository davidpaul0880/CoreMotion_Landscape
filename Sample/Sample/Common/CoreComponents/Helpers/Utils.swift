//
//  Utils.swift
//  proximeet
//
//  Created by Jijo Pulikkottil on 18/01/17.
//  Copyright © 2017 inrangecontacts. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    static let screenWidth         = UIScreen.main.bounds.size.width
    static let screenHeight        = UIScreen.main.bounds.size.height
    static let screenMaxLength    = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength    = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let isIphone            = UIDevice.current.userInterfaceIdiom == .phone
    static let isIphone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let isIphone5OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength <= 568.0
    static let isIphone5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    static let isIphone6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let isIphone6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let isIphone7          = isIphone6
    static let isIphone7P         = isIphone6P
    static let isIphone8          = isIphone6
    static let isIphone8P         = isIphone6P
    static let isIphoneX         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 812.0
    static let isIPhonePlusOrX   = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength >= 736.0
    static let isIpad              = UIDevice.current.userInterfaceIdiom == .pad// && ScreenSize.screenMaxLength == 1024.0
    static let isIpadPro1366     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screenMaxLength == 1366.0
    static let isTV                = UIDevice.current.userInterfaceIdiom == .tv
    static let isCarPlay          = UIDevice.current.userInterfaceIdiom == .carPlay
}

struct Version {
    static let sysVersion = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.sysVersion < 8.0 && Version.sysVersion >= 7.0)
    static let iOS8 = (Version.sysVersion >= 8.0 && Version.sysVersion < 9.0)
    static let iOS9 = (Version.sysVersion >= 9.0 && Version.sysVersion < 10.0)
    static let iOS10 = (Version.sysVersion >= 10.0 && Version.sysVersion < 11.0)
}
class Utils {

    class func getVendorID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    //private let phoneNumberKit = PhoneNumberKit()

//    func getFormattedPhoneNumber(numberWithCountryCode: inout String) -> String {
//
//        do {
//            let parsedNumber = try phoneNumberKit.parse(numberWithCountryCode)
//
//            let myCCode = phoneNumberKit.countryCode(for: PhoneNumberKit.defaultRegionCode())
//
//            if parsedNumber.countryCode == myCCode {
//                numberWithCountryCode = String(parsedNumber.nationalNumber)
//            } else {
//                numberWithCountryCode = parsedNumber.numberString
//            }
//            numberWithCountryCode = PartialFormatter().formatPartial(numberWithCountryCode)
//        } catch {
//            printDebug("in catch")
//        }
//        return numberWithCountryCode
//    }

    class func jsonToString(json: AnyObject) -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString

        } catch let myJSONError {
            printDebug(myJSONError)
            return nil
        }

    }

    // MARK: - Delay methods - especially to invoke a method in main thread with delay.

    class func addDelayInSeconds(_ seconds: Double, delayhandler: @escaping DelayHandler) {

        let delayTime = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            delayhandler()
        }
    }

    // MARK: - Check Device by Screen size

    class func isIPhone6plus() -> Bool {
        return (UIScreen.main.bounds.size.height >= 736.0)
    }
    class func isIphone5OrBelow() -> Bool {
        return UIScreen.main.bounds.size.height <= 568
    }
}
func + <K, V>(left: [K: V], right: [K: V])
    -> [K: V] {
        var map = [K: V]()
        for (k, v) in left {
            map[k] = v
        }
        for (k, v) in right {
            map[k] = v
        }
        return map
}
//
//func + <K, V>(left: Dictionary<K, V>, right: Dictionary<K, V>)
//    -> Dictionary<K, V> {
//    var map = Dictionary<K, V>()
//    for (k, v) in left {
//        map[k] = v
//    }
//    for (k, v) in right {
//        map[k] = v
//    }
//    return map
//}
