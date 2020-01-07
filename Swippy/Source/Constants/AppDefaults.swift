//
//  AppDefaults.swift
//  Swippy
//
//  Created by Sudipta Sahoo on 05/01/20.
//  Copyright © 2020 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

//MARK: App Defaults
public enum Defaults {
    static let defaultPageSize: Int = 30
    static let firstPage: Int = 1
    static let defaultPageNum: Int = 0
    static let defaultTotalCount: Int = 0
}

//MARK: Metrics
enum Metrics {
    static let screenWidth = UIScreen.main.bounds.width
    static let cardWidth: CGFloat = Metrics.screenWidth - (28.0 * 2)
    static let cardHeight: CGFloat = Metrics.cardWidth / 1.66 //1.66 is the credit card aspect ratio
}

//MARK: Card
enum Card {
    
    ///The percentage of the card to be opened max eitehr on left or right. This is calculated against the card width
    static let openPercentage: CGFloat = 60.0
    
    ///The minimum swipe distance to be considered for the successfull transition to left/right/center. This is calculated against the card width
    static let panThresholdPercentage: CGFloat = 10.0
    
    ///The percentage of the card of the opened/auto swiped while demo
    static let demoSwipePercentage: CGFloat = 20.0
    
    static let inset: UIEdgeInsets = UIEdgeInsets(top: 30, left: 16, bottom: -30, right: -16)
}

//MARK:- UI Testing identifiers
public enum UITestIdentifiers {
    static let cardTable = "card_table"
}

enum Errors {
    static let somethingWentWrong = "Something went wrong"
    static let noCard = "No card present at this index"
}
