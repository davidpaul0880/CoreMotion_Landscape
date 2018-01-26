//
//  HomeRouter.swift
//  Sample
//
//  Created by jijo pulikkottil on 17/01/18.
//  Copyright © 2018 jijo. All rights reserved.
//

import Foundation
import UIKit
enum HomeSegue: String {
    case showProfile = "ShowProfileViewController"
    case showDetail = "ShowDetailViewController"
    func identifier() -> String {
        return self.rawValue
    }
}
final class HomeRouter: BaseNavigation {
    static func addContracts(_ viewController: HomeViewController) {
        let router = HomeRouter(with: viewController)
        viewController.router = router//assigned to instance in BaseViewController
    }
}
extension HomeRouter: Navigator {
    func perform(_ segue: HomeSegue, sender: Any?) {
        switch segue {
        case .showProfile: // this is a manual segue
            viewController.performSegue(withIdentifier: segue.rawValue, sender: sender)
        case .showDetail: //this is an action segue
            break
        }
    }
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let actionSegue = HomeSegue(rawValue: identifier) else {
            fatalError("identifier not defined or not matched with defined LoginSegue")
        }
        switch actionSegue {
        case .showDetail:
            guard let viewController = segue.destination as? DetailViewController else {
                return
            }
            DetailRouter.addContracts(viewController)
        case .showProfile:
            break
        }
        
    }
}
