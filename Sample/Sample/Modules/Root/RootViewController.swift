//
//  RootViewController.swift
//  proximeet
//
//  Created by ZCo Engg Dept on 24/08/16.
//  Copyright © 2016 zco. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaults.standard.registerDefaultSpeeds()
        bootStrap()
        launchSplash()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension RootViewController: SplashNavigationDelegate {
    func dismissSplashScreen(_ splashController: UIViewController?) {
        if 1 == 2 { //let profile = MyProfile.load() {
            AppCommon.sharedInstance.launchHomeByRemove(splashController)
        } else {
            AppCommon.sharedInstance.showLoginByRemove(splashController)
        }
    }
}
private extension RootViewController {

    func launchSplash() {
        let spashController = SplashViewController.getController()
        spashController.navigationDelegate = self
        self.addChildVC(spashController)
    }
    /// To remove current navigation controller
    ///
    /// - Parameter viewController:
    func removeView(_ viewController: UIViewController?) {
        if let vc = viewController {
            if let nvc = vc as? UINavigationController {
                nvc.popToRootViewController(animated: false)
            }
            vc.releaseMeFromParent()
        }
    }
    func bootStrap() {
        UINavigationBar.appearance().barTintColor = UIColor.navigationBarBackground()
        UINavigationBar.appearance().tintColor = UIColor.white
    }
}
