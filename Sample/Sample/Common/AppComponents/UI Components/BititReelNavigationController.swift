//
//  BititReelNavigationController.swift
//  JPulikkottil
//
//  Created by Admin on 26/10/17.
//  Copyright © 2017 JPulikkottil. All rights reserved.
//

import UIKit

class BititReelNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .landscape
    }
    private func shouldAutorotate() -> Bool {
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
