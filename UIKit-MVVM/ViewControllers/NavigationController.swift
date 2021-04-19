//
//  See LICENSE file for this project's licensing information.
//

import UIKit

/// The root view controller for our app
class NavigationController: UINavigationController {
    
    /// The root view controller for our app
    init() {
        super.init(rootViewController: ListController())
    }
    
    /// Helper init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
