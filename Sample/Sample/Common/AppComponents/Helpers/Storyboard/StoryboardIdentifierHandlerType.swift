//
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 07/04/16.
//  Copyright © 2017 JPulikkottil All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }

    class var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: Bundle.main)
    }

    class var common: UIStoryboard {
        return UIStoryboard(name: "Common", bundle: Bundle.main)
    }
    class var video: UIStoryboard {
        return UIStoryboard(name: "Video", bundle: Bundle.main)
    }
    class var tutorial: UIStoryboard {
        return UIStoryboard(name: "Tutorial", bundle: Bundle.main)
    }
}

/**
 A protocol specific to the Lister sample that represents the segue identifier
 constraints in the app. Every view controller provides a segue identifier
 enum mapping. This protocol defines that structure.
 
 We also want to provide implementation to each view controller that conforms
 to this protocol that helps box / unbox the segue identifier strings to
 segue identifier enums. This is provided in an extension of `SegueHandlerType`.
 */
public protocol StoryboardIdentifiable {

    static func storyboard() -> UIStoryboard
    static func instantiateViewControllerFromStoryboard(_ storyBoard: UIStoryboard, storyboardID: String) -> UIViewController
}

extension StoryboardIdentifiable where Self: UIViewController {

    public static func getController() -> Self {
        guard let ctrlr =  Self.instantiateViewControllerFromStoryboard(storyboard(), storyboardID: String(describing: Self.self)) as? Self else {
            fatalError("getController cast issue")
        }
        return ctrlr
    }

    static func instantiateViewControllerFromStoryboard(_ storyBoard: UIStoryboard, storyboardID: String) -> UIViewController {
        return storyBoard.instantiateViewController(withIdentifier: storyboardID)
    }
}
