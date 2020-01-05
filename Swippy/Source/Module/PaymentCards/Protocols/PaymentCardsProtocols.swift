//
//  PaymentCardsProtocols.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum ViewState : Equatable {
    case none
    case loading
    case content
    case error(message: String)
}

//MARK: View
protocol PaymentCardsViewInput: AnyObject {
    
    /// Refreshes the search screen UI
    /// - Parameter state: intended view state
    func updateViewState(with state: ViewState)
    
    /// Insert Cards at specified index path of tableview
    /// - Parameter indexPaths: list of index paths to be inserted at
    func insertCards(at indexPaths: [IndexPath])
    
}

//MARK: Presenter
protocol PaymentCardsViewOutput: AnyObject {
    
    /// The single source of truth about the current state
    var pCardViewModel: PCardViewModel { get }
    
    /// Fetches cards from the Presenter
    func fetchCards()
    
    /// Card was tapped by the user
    /// - Parameter index: the index location of the card
    func viewCardDetails(at index: Int)
    
    /// Pay Now was tapped for the card
    /// - Parameter index: the index location of the card
    func payNowCard(at index: Int)
    
    ///Add New card button tapped by the user
    func addNewCardTapped()
}

protocol PaymentCardsModuleInput: AnyObject {
    //MARK: Presenter Variables
    var view: PaymentCardsViewInput? { get set }
    var interactor: PaymentCardsInteractorInput! { get set }
    var router: PaymentCardsRouterInput! { get set }
}

//MARK: Interactor
protocol PaymentCardsInteractorInput: AnyObject {
    
    ///Fetch new/next set of Payment Cards from the server
    func fetchCards(from page: Int) -> Observable<PCardResponse>
}

//MARK: Router
protocol PaymentCardsRouterInput: AnyObject {
    
    ///Pay now using the selected card
    /// - Parameter card: the payment card selected by the user
    func payNow(with card: PCard)
    
    ///View details of the selected card
    /// - Parameter card: the payment card selected by the user
    func viewDetails(of card: PCard)
    
    ///Routes to Add New payment card module
    func addNewCard()
    
}

//MARK: PaymentCardsModuleBuilder
protocol PaymentCardsBuilder {
    static func buildModule() -> PaymentCardsViewController
}

