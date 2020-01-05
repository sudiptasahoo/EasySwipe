//
//  PaymentCardsProtocols.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

//MARK: View
protocol PaymentCardsViewInput: AnyObject {
    //TODO: Declare ViewInput methods
}

//MARK: Presenter
protocol PaymentCardsViewOutput: AnyObject {
    //TODO: Declare presenter methods
}

protocol PaymentCardsModuleInput: AnyObject {
    //MARK: Presenter Variables
    var view: PaymentCardsViewInput? { get set }
    var interactor: PaymentCardsInteractorInput! { get set }
    var router: PaymentCardsRouterInput! { get set }
}

//MARK: Interactor
protocol PaymentCardsInteractorInput: AnyObject {
    //TODO: Declare interactor methods
}

//MARK: Router
protocol PaymentCardsRouterInput: AnyObject {
    //TODO: Declare router methods
}

//MARK: PaymentCardsModuleBuilder
protocol PaymentCardsBuilder {
    static func buildModule() -> PaymentCardsViewController
}

