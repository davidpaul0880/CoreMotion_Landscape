//
//  UIViewControllerExtension.swift
//  BitReel
//
//  Created by Admin on 19/10/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func transition(fromVC: UIViewController?, animationDuration: Double, toVC: UIViewController? = nil, completion: ((Bool) -> Void)? = nil) {
        if let newController = toVC {
            view.addSubview(newController.view)
            view.sendSubview(toBack: newController.view)
        }
        guard let existing = fromVC else {
            if let newController = toVC {
                addChildViewController(newController)
                newController.didMove(toParentViewController: self)
                view.bringSubview(toFront: newController.view)
            }
            return
        }
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIViewAnimationOptions.curveLinear], animations: {
            existing.view.alpha = 0
        }, completion: { (_) in
            existing.view.removeFromSuperview()
            existing.removeFromParentViewController()
            if let newController = toVC {
                self.addChildViewController(newController)
                newController.didMove(toParentViewController: self)
                self.view.bringSubview(toFront: newController.view)
            }
        })
    }
    func addChildVC(_ child: UIViewController) {
        view.addSubview(child.view)
        child.view.frame = view.bounds
        addChildViewController(child)
        child.didMove(toParentViewController: self)
    }
    func transition(to child: UIViewController, completion: ((Bool) -> Void)? = nil) {
        let duration = 0.3
        let current = childViewControllers.last
        addChildViewController(child)
        let newView = child.view!
        newView.translatesAutoresizingMaskIntoConstraints = true
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newView.frame = view.bounds
        if let existing = current {
            existing.willMove(toParentViewController: nil)
            transition(from: existing, to: child, duration: duration, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                existing.removeFromParentViewController()
                child.didMove(toParentViewController: self)
                completion?(done)
            })
        } else {
            view.addSubview(newView)
            UIView.animate(withDuration: duration, delay: 0, options: [.transitionCrossDissolve], animations: { }, completion: { done in
                child.didMove(toParentViewController: self)
                completion?(done)
            })
        }
    }
}
