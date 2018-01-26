//
//  BaseNavigation.swift
//  bitreel
//
//  Created by jijo pulikkottil on 22/06/17.
//  Copyright © 2017 jijo. All rights reserved.
//

import Foundation
import UIKit

protocol BaseNavigator: class {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}
protocol Navigator: BaseNavigator {
    associatedtype SegueEnumString
    func perform(_ segue: SegueEnumString, sender: Any?)
}

class BaseNavigation {

    weak var viewController: UIViewController!

    init(with viewController: UIViewController) {
        self.viewController = viewController
    }
    func push(nextViewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {

        if let navigationController = viewController.navigationController {
            _ = navigationController.pushViewController(nextViewController, animated: animated)
        } else {
            viewController.present(nextViewController, animated: animated, completion: completion)
        }
    }

    func pop() {
        _ = viewController.navigationController?.popViewController(animated: true)
    }

    func present(modalViewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController.present(modalViewController, animated: animated, completion: completion)
    }

    func dismissMe(animated: Bool, completion: (() -> Void)? = nil ) {
        viewController.dismiss(animated: true, completion: completion)
    }

}
