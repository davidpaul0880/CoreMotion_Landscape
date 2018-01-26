//
//  Result.swift
//  bitreel
//
//  Created by ZCo Engg Dept on 23/08/16.
//  Copyright © 2016 zco. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(MOError)
}
