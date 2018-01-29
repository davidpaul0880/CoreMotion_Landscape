//
//  BaseViewController.swift
//  bitreel
//
//  Created by jijo pulikkottil on 29/03/17.
//  Copyright © 2017 jijo. All rights reserved.
//

import UIKit
protocol InPutUIController {
    func initialize()
    func viewWillAppear()
    func viewWillDisAppear()
    func dismissKeyboard()
}

class BaseViewController: UIViewController {

    var router: BaseNavigator?
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBarButtons()
        //to empty the back button text. And we are setting the back button image in viewDidLoad of TWNRootViewController
        //let backButton =  UIBarButtonItem(title: " ", style: .done, target: nil, action: nil)
        //self.navigationItem.backBarButtonItem = backButton
        // Register to receive notification
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var shouldAutorotate: Bool {
        return true
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        router?.prepare(for: segue, sender: sender)
    }
}
extension BaseViewController: StoryboardIdentifiable {
    @objc class func storyboard() -> UIStoryboard {
        return UIStoryboard.main
    }
}
