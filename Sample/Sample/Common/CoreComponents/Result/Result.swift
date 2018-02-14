//
//  Result.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 23/08/16.
//  Copyright © 2017 JPulikkottil All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(MOError)
}
