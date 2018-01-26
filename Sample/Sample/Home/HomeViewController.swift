//
//  ViewController.swift
//  Sample
//
//  Created by jijo pulikkottil on 17/01/18.
//  Copyright © 2018 jijo. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //As it is set as root view, we are calling it from didLoad.
        HomeRouter.addContracts(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

