//
//  SplashViewController.swift
//  BitReel
//
//  Created by Admin on 16/10/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import UIKit
protocol SplashNavigationDelegate: class {
    func dismissSplashScreen(_ splashController: UIViewController?)
}
class SplashViewController: UIViewController {
    weak var navigationDelegate: SplashNavigationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let delay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationDelegate?.dismissSplashScreen(strongSelf)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        printDebug("\(String(describing: self)) is being deInitialized.")
    }

}
extension SplashViewController: StoryboardIdentifiable {
    class func storyboard() -> UIStoryboard {
        return UIStoryboard.main
    }
}
