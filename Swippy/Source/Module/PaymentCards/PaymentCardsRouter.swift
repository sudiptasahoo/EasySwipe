//
//  PaymentCardsRouter.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

final class PaymentCardsRouter: PaymentCardsRouterInput {

    //MARK: Properties
    private weak var viewController: PaymentCardsViewController?
    
    
    //MARK: Initialiser
    init(viewController: PaymentCardsViewController) {
        self.viewController = viewController
    }
    
    //MARK: PaymentCardsRouterInput methods
}

