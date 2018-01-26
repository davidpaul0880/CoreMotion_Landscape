//
//  Constants.swift
//  sample
//
//  Created by ZCo Engg Dept on 24/08/16.
//  Copyright © 2016 zco. All rights reserved.
//

import Foundation

var globalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

var globalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
}

var globalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
}

var globalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
}

var globalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
}

