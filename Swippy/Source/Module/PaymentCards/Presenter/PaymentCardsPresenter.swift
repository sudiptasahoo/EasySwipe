//
//  PaymentCardsPresenter.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import RxSwift

final class PaymentCardsPresenter: PaymentCardsViewOutput, PaymentCardsModuleInput {
    
    //MARK: Properties
    weak var view: PaymentCardsViewInput?
    var router: PaymentCardsRouterInput!
    var interactor: PaymentCardsInteractorInput!
    var pCardViewModel: PCardViewModel
    var disposeBag = DisposeBag()
    
    //MARK: Initialization
    init() {
        pCardViewModel = PCardViewModel.default
    }
    
    //MARK: PaymentCardsViewOutput methods
    
    func fetchCards() {
        
        interactor.fetchCards(from: pCardViewModel.currentPage + 1)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (pCardResponse) in
                guard let self = self else { return }
                self.pCardViewModel.load(from: pCardResponse)
                self.view?.updateViewState(with: .content)
                
            }, onError: {[weak self] (error) in
                guard let self = self else { return }
                self.view?.updateViewState(with: .error(message: error.localizedDescription))
            })
            .disposed(by: disposeBag)
    }
    
    func viewCardDetails(at index: Int) {
        guard let pCard = try? pCardViewModel.getCard(at: index) else { return }
        router.viewDetails(of: pCard)
    }
    
    func payNowCard(at index: Int) {
        guard let pCard = try? pCardViewModel.getCard(at: index) else { return }
        router.payNow(with: pCard)
    }
    
    func addNewCardTapped() {
        router.addNewCard()
    }
}

