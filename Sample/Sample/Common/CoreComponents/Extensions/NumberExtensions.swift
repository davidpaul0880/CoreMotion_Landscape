//
//  NumberExtensions.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 16/08/16.
//  Copyright © 2017 JPulikkottil All rights reserved.
//

import Foundation

extension Int {
    var degreesToRadians: Double { return Double(self) * Double.pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / Double.pi }
}
extension Double {
    func toMiles() -> Double {
        return self * 0.000621371
    }
    func toDegree() -> Float {//+20171209
        return Float(self * 180.0/Double.pi)
    }
}
