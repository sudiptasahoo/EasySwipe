//
//  PaymentCardsInteractor.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 03/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import RxSwift

final class PaymentCardsInteractor: PaymentCardsInteractorInput {
    
    //MARK: Properties
    var network: MockNetwork!
    
    //MARK: Initialization
    init() {
        network = MockNetwork()
    }
    
    //MARK: PaymentCardsInteractorInput methods
    func fetchCards(from page: Int) -> Observable<PCardResponse> {
        
        if let response = network.fetchPaymentCards(with: page, pageSize: Defaults.defaultPageSize) {
            return Observable.just(response)
        } else {
            return Observable.error(AppError.networkError(reason: "Invalid data in MockData.json or file not present"))
        }
    }
}

