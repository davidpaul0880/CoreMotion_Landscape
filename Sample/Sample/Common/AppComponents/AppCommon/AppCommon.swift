//
//  Common.swift
//  sample
//
//  Created by ZCo Engg Dept on 24/08/16.
//  Copyright © 2016 zco. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let horizontalRailXSpeed = 75.0
}

// Callback handlers
typealias DelayHandler = () -> Void
typealias AlertButtonActionHandler = () -> Void

class AppCommon {
    private var activityView: SpinnerView?
    static let sharedInstance = AppCommon()
    private var isAnimating: Bool = false
    class func setNetWorkIndicatorVisible(_ toggle: Bool) {
        globalMainQueue.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = toggle
        }
    }
    private init() {
    }
    // MARK: Activity View
    func isShowingIndicator() -> Bool {
        if self.activityView != nil {
            return isAnimating//activity.isAnimating
        } else {
            return false
        }
    }
    func getWindow() -> UIWindow {
        return ((UIApplication.shared.delegate?.window)!)!
    }
    func showActivity(_ isShow: Bool = true, _ isTappble: Bool = true) { //20171221 tappble added for manual cancel
        if isShow {
            showActivityIndcator(isTappble) //20171221 isTappble
        } else {
            hideActivityIndcator()
        }
    }
    func showActivityIndcator(_ isTappble: Bool = true) {  //20171221 isTappble to true
        if UIApplication.shared.keyWindow == nil { printError("window not created yet")
            return }
        isAnimating = true
        let window = getWindow()
        if self.activityView == nil {
            self.activityView = SpinnerView(frame: window.bounds)
            self.activityView!.layer.zPosition = 1002
        }
        if self.activityView!.superview == nil {
            window.addSubview(self.activityView!)
        }
        self.activityView?.isUserInteractionEnabled = isTappble  //20171221 isTappble to true
        self.activityView!.startAnimate()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func hideActivityIndcator() {
        isAnimating = false
        activityView?.stopAnimate()
        activityView?.removeFromSuperview()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    // MARK: - Alert methods
    func showErrorAlert(error: MOError, onViewController viewController: UIViewController? = nil, completionHandler: AlertButtonActionHandler? = nil) {

    }
    func showSimpleAlert(message: String? = nil, onViewController viewController: UIViewController? = nil, withActionHandler actionHandler: AlertButtonActionHandler? = .none) {

    }
    // swiftlint:disable line_length
    func showConfirmationAlert(_ title: String = "title.app".localized(), message: String, onViewController: UIViewController? = nil, okButtonTitle: String? = "alert.button.yes".localized(), cancelButtonTitle: String? = "alert.button.cancel".localized(), okButtonAction: AlertButtonActionHandler?, cancelButtonAction: AlertButtonActionHandler? = nil) {
    }
}
