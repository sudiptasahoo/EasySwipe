//
//  PaymentCardsPresenter.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation

final class PaymentCardsPresenter: PaymentCardsViewOutput, PaymentCardsModuleInput {

    //MARK: Properties
    weak var view: PaymentCardsViewInput?
    var router: PaymentCardsRouterInput!
    var interactor: PaymentCardsInteractorInput!
    
    //MARK: Initialization
    init() {
        
    }
    
    //MARK: PaymentCardsViewOutput methods
}

