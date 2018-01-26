//
//  DetailRouter.swift
//  Sample
//
//  Created by jijo pulikkottil on 17/01/18.
//  Copyright © 2018 jijo. All rights reserved.
//

import Foundation
import UIKit
enum DetailSegue: String {
    case backToHome
    func identifier() -> String {
        return self.rawValue
    }
}
final class DetailRouter: BaseNavigation {
    static func addContracts(_ viewController: DetailViewController) {
        let router = DetailRouter(with: viewController)
        viewController.detailRouter = router
        viewController.router = router//assigned to instance in BaseViewController
    }
}
extension DetailRouter: Navigator {
    func perform(_ segue: DetailSegue, sender: Any?) {
        switch segue {
        case .backToHome: // this is a manual segue
            dismissMe(animated: true)
        }
    }
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let actionSegue = DetailSegue(rawValue: identifier) else {
            fatalError("identifier not defined or not matched with defined LoginSegue")
        }
    }
}
