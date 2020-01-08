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
    func payNow(with card: PCard) {
        var message = "Title: \(card.title) \nCard No.:\(card.number)"
        if let due = card.due {
            message += "\nDue: \(due.currency) \(due.amount)"
        }
        viewController?.showAlert(title: "Pay Now", message: message)
    }
    
    func viewDetails(of card: PCard) {
        let message = "Title: \(card.title) \nCard No.:\(card.number)"
        viewController?.showAlert(title: "View Details", message: "This will open the card details screen. \n\(message)")
    }
    
    func viewLastStatment(of card: PCard) {
        let message = "Title: \(card.title) \nCard No.:\(card.number)"
        viewController?.showAlert(title: "View Last Statement Details", message: "This will open the card last statement details screen. \n\(message)")
    }
    
    func addNewCard() {
        viewController?.showAlert(title: "Add New Card", message: "Add New Card tapped. This will init the AddNewCard module and let the user add a new card")
    }
    
}

