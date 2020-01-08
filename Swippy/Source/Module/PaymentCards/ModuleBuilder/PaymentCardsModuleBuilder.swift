//
//  PaymentCardsModuleBuilder.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

struct PaymentCardsModuleBuilder: PaymentCardsBuilder {
    
    //MARK: PaymentCardsBuilder method
    static func buildModule() -> PaymentCardsViewController {
        let viewController = PaymentCardsViewController()
        let router = PaymentCardsRouter(viewController: viewController)
        let interactor = PaymentCardsInteractor(network: MockNetwork())
        let presenter = PaymentCardsPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return viewController
    }
}
