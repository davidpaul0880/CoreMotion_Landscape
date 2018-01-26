//
//  UICollectionView+Dequeuing.swift
//  bitreel
//
//  Created by ZCo Engg Dept on 02/05/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell: Reusable { }
extension UICollectionView {
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) { // where T: Reusable
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    func registerReusableNib<T: UICollectionViewCell>(_: T.Type) { // where T: Reusable
        let nib = UINib(nibName: T.reuseIdentifier, bundle: Bundle.main)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T { // where T: Reusable
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("reuseidentifier name should same as the class name")
        }
        return cell
    }
}
