//
//  DetailViewController.swift
//  Sample
//
//  Created by jijo pulikkottil on 17/01/18.
//  Copyright © 2018 jijo. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {
    weak var detailRouter: DetailRouter?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backToHome() {
        detailRouter?.perform(.backToHome, sender: nil)
    }

}
