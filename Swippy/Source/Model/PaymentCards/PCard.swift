//
//  PCard.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation


struct PCardViewModel {
    
    //default singleton instance
    static let `default` = PCardViewModel(cards: [], totalPage: Defaults.defaultTotalCount, currentPage: Defaults.defaultPageNum)
    
    /// List of cards fetched from the server up till now
    private var cards: [PCard]
    
    /// Total no of pages in the paginated result
    var totalPage: Int
    
    
    /// Last fetched page from the API
    var currentPage: Int
    
    
    /// Whether ViewModel has any cards
    var isEmpty: Bool {
        get{
            return cards.isEmpty
        }
    }
    
    /// Append freshly cards fetched from the API
    mutating func append(_ cards: [PCard]) {
        self.cards += cards
    }
    
    /// Total count of the cards
    var cardCount: Int {
        return cards.count
    }
    
    /// Returns PCard at the specified index
    /// - Parameter index: requested index no
    func getCard(at index: Int) throws -> PCard {
        guard let card = cards[safe: index] else {
            throw AppError.cardError(.noCardPresent)
        }
        return card
    }
    
    /// Reset the ViewModel before fetching results for new search term from the API
    mutating func reset() {
        cards = []
        currentPage = Defaults.defaultPageNum
        totalPage = Defaults.defaultTotalCount
    }
    
    mutating func load(from pCardResponse: PCardResponse) {
        append(pCardResponse.card)
        currentPage = pCardResponse.page
        totalPage = pCardResponse.pages
    }
}

struct PCardResponse: Decodable{
    
    var page: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var card: [PCard]
    var stat: String
}

enum PCardType: String, Decodable {
    
    case HDFC
    case SBI
    case CITI
    case STANC
    case YES
    case ICICI
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try PCardType(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }
}

enum PCardBank: String, Decodable {
    
    case MASTERC
    case VISA
    case DINERS
    case AMEX
    case DISCOVER
    case unknown
    
    public init(from decoder: Decoder) throws {
        self = try PCardBank(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }
}

struct PCard: Decodable {
    
    var id: String
    var title: String
    var number: String
    var cardHolderName: String
    var type: PCardType
    var bankName: PCardBank
    var due: PCardDue?
}

struct PCardDue: Decodable {
    
    var id: String
    var amount: Double
    var currency: String
    var state: PCardDueState
}

enum PCardDueState: Decodable {
    
    case fullyPaid
    case due(interval: String)
    case unknown
    
    init(from decoder: Decoder) throws {
        
        let value = try decoder.singleValueContainer().decode(String.self)
        
        if value == "fully_paid" {
            self = .fullyPaid
        } else {
            self = .due(interval: value)
        }
    }
}
