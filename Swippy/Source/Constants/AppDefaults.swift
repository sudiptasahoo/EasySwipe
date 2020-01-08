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
}

//MARK:- UI Testing identifiers
public enum UITestIdentifiers {
    static let cardTable = "card_table"
}

public enum CardUI {
    //The inset around the card contents
    static let inset: UIEdgeInsets = UIEdgeInsets(top: 30, left: 16, bottom: -30, right: -16)
    
    static let cardWidth: CGFloat = Metrics.screenWidth - (28.0 * 2)
    static let cardHeight: CGFloat = (Metrics.screenWidth - (28.0 * 2)) / 1.58 //1.58 is the credit card aspect ratio
    static let dueViewHeight: CGFloat = 60.0
}

enum Errors {
    static let somethingWentWrong = "Something went wrong"
    static let noCard = "No card present at this index"
}
