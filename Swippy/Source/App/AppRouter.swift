//
//  AppRouter.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

final public class AppRouter {
    
    @discardableResult
    func configureRootViewController(inWindow window: UIWindow?) -> Bool {
        let searchVc = PaymentCardsModuleBuilder.buildModule()
        let navigationController = UINavigationController(rootViewController: searchVc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
