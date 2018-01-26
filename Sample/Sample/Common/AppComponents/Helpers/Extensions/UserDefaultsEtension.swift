//
//  UserDefaultsEtension.swift
//  BitReel
//
//  Created by jijo pulikkottil on 19/11/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import Foundation
extension UserDefaults {
    enum Key: String {
        case horizontalRailXSpeed
        case horizontalRailYSpeed
        case veriticalRailXSpeed
        case veriticalRailYSpeed
        case isDebugging
    }
    var isDebugging: Bool {
        get {
            return self.bool(forKey: UserDefaults.Key.isDebugging.rawValue)
        }
        set {
            self.set(newValue, forKey: UserDefaults.Key.isDebugging.rawValue)
        }
    }
}
